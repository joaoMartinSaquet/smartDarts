from collections import deque
import numpy as np
from torch import nn 
from torch import optim
import torch    
from godot_rl.core.godot_env import GodotEnv


from deep_stuff import networks
from user_simulator import *
from perturbation import *

# steps where we say, that's enough reset yourselves
MAXSTEPS =int(1e6)

class Corrector():
    def __init__(self, learn = False):
        self.learning = learn
        self.feedback_list = []
        self.step = 0

    def reset(self):

        self.step = 0
        self.feedback_list = []


    def __call__(self, input):
        return input
    

    def get_feedback(self, fb):
        """function register the feedback that occurs inside the env (reward, done, etc...)

        Args:
            fb (_type_): _description_
        """

        self.feedback_list = []



class LowPassCorrector(Corrector):
    ''' averages overs 5 steps and then applies the correction'''
    def __init__(self, nsteps = 5,learn = False):
        super().__init__(learn)
        self.feedback_list = []
        self.step = 0
        self.inputs = deque(maxlen = nsteps)
        self.nsteps = nsteps

    def __call__(self, input):
        self.inputs.append(input)

        if len(self.inputs) == self.nsteps:
            return np.mean(self.inputs, axis=0)
        else:
            return input    
        

        
class ReinforceCorrector(Corrector):
    ''' 
        Inpired from : https://www.geeksforgeeks.org/reinforce-algorithm/ 
    '''
    def __init__(self, env : GodotEnv, u_sim : UserSimulator, learn = False):
        super().__init__(learn)

        # algorithm hyperparameters
        self.gamma = 0.99  # Discount factor
        self.learning_rate = 0.01
        self.num_episodes = 500
        self.batch_size = 64

        self.seed = 0

        self.mean_network = networks(n_input = 2, n_output = 2, layers = [16, 16])
        self.std_network = networks(n_input = 2, n_output = 2, layers = [16, 16])

        self.optimizer = optim.Adam(list(self.mean_network.parameters()) + list(self.std_network.parameters()), lr=self.learning_rate)
        # self.criterion = nn.MSELoss()

        # it s a godot env !
        self.env = env 
        self.u_sim = u_sim


    def compute_return(self, rewards): 
        G = np.zeros(len(rewards))
        running_return = 0
        
        for t in reversed(range(len(rewards))):
            running_return = self.gamma * running_return + rewards[t][0]
            G[t] = running_return
        return G


    def train_step(self, obss, actions, rewards):
        
        G = self.compute_return(rewards)
        means_actions = self.mean_network(obss)
        std_actions = self.std_network(obss)

        stds = torch.exp(std_actions)
        dist = torch.distributions.Normal(means_actions, stds)
            
        action = dist.sample()
        log_probs = dist.log_prob(actions).sum(dim=-1)


        # Compute policy loss
        # print(G)
        policy_loss = -(log_probs * torch.tensor(G)).mean()

        # Backward pass
        self.optimizer.zero_grad()
        policy_loss.backward()
        self.optimizer.step()


    def training_loop(self):

        ep_reward = []

        for episode in range(self.num_episodes):
            print("reset env , episode : ",episode)
            observation, info = self.env.reset(seed=self.seed)
            xinit = np.array(observation[0]["obs"][2:]) 

            self.u_sim.reset(xinit)

            done = False
            states, actions, rewards = [], [], []

            for t in range(MAXSTEPS):
                    
                obs = np.array(observation[0]["obs"])

                # get simulator movements 
                move_action, click_action = self.u_sim.step(obs[:2], obs[2:])

                state = torch.tensor(move_action, dtype=torch.float32)
                means = self.mean_network(state)
                log_stds = self.std_network(state)

                stds = torch.exp(log_stds)

                dist = torch.distributions.Normal(means, stds)
                corrector_action = dist.sample()

                # contruct msg to be send to the env
                # print("corrector actions : ",corrector_action)
                smartDart_action = np.insert(np.clip(corrector_action, -80, 80), 0 , click_action)
                smartDart_action = np.array([ smartDart_action for _ in range(self.env.num_envs) ])
                


                next_observation, reward, done, info, _ = self.env.step(smartDart_action)

                done = any(done)

                states.append(state)
                actions.append(corrector_action)
                rewards.append(reward)

                observation = next_observation

                # print("step : ",t, " reward : ", reward)
                if done:
                    break
            # print("done ! episode : ",episode)

            print("rewards summ at ep ", episode, " : ", np.sum(rewards))
            ep_reward.append(np.sum(rewards))

            self.train_step(torch.stack(states), torch.stack(actions), rewards)

            np.save("rewards.npy", np.array(ep_reward))






if __name__ == "__main__":
    

        # create a perturbation
    perturbator = NormalJittering(0, 20)
    # perturbator = None


    # create a corrector
    corrector = None
    # corrector = LowPassCorrector(5)

    # Initialize the environment
    env = GodotEnv(convert_action_space=True)
    
    
    u_sim = VITE_USim([0, 0])

    corr = ReinforceCorrector(env, u_sim)
    # corr.training_loop(Corrector)
    corr.training_loop()

    env.close()