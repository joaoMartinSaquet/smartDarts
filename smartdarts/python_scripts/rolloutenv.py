from godot_rl.core.godot_env import GodotEnv
from gymnasium import spaces
import numpy as np
from user_simulator import *
from perturbation import *
from corrector import *


MAX_DISP = 60


def stepSmartDartEnv(env, obs, u_simulator : UserSimulator, perturbator : Perturbator, corrector = None):
    """
        Does'nt work we need to place our corrector inside... 
    """
    obs = np.array(observation[0]["obs"])
    move_action, click_action = u_simulator.step(obs[:2], obs[2:])
    
    # clamp action to don't have to big displacement
    move_action = np.clip(move_action, -MAX_DISP, MAX_DISP)

    # add perturbation and corrector
    if perturbator is not None:
        observation = perturbator(observation)
    if corrector is not None:
        observation = corrector(observation)
    

    # contruct msg to be send to the env
    action = np.insert(move_action, 0 , click_action)
    action = np.array([ action for _ in range(env.num_envs) ])

    observation, reward, done, info, _ = env.step(action)

    return observation, reward, done, info

def rolloutSmartDartEnv(env, Nstep, pertubator : Perturbator, corrector = None, seed = 0):

    observation, info = env.reset(seed=seed)
    
    # initialize controller
    # xinit = np.array(observation[0]["obs"][2:] + [0, 0]) 
    xinit = np.array(observation[0]["obs"][2:]) 

    u_simulator = VITE_USim(xinit)
    
    perturbator = pertubator
    reward_list = []
    # rolling out env
    for i in range(Nstep):
        # get controller actions and process it (clamp, norm, pert, etc...)
        obs = np.array(observation[0]["obs"])

        move_action, click_action = u_simulator.step(obs[:2], obs[2:])

        # add perturbation if there is any
        if perturbator is not None:
            move_action = perturbator(move_action)

        if corrector is not None:
            move_action = corrector(move_action)


        # clamp action to don't have to big displacement
        move_action = np.clip(move_action, -MAX_DISP, MAX_DISP)
        
        # contruct msg to be send to the env
        action = np.insert(move_action, 0 , click_action)
        action = np.array([ action for _ in range(env.num_envs) ])

        # step the env
        # print("action sended at step {i}, action = {action}".format(i = i, action = action))
        observation, reward, done, info, _ = env.step(action)

        # print("done , reward = ", done, reward)
        # see how to do this with several env 
        if any(done):
            print("done")
            break

        # update reward list
        reward_list.append(reward)

    return np.cumsum(reward_list), reward_list

        


if __name__ == "__main__":
    
    N = 1

    # create a perturbation
    # perturbator = NormalJittering(0, 20)
    perturbator = None


    # create a corrector
    corrector = None
    # corrector = LowPassCorrector(5)

    # Initialize the environment
    env = GodotEnv(convert_action_space=True)


    for j in range(N):
        print("ep : ", j)
        # Run the environment
        r_summ, r_list = rolloutSmartDartEnv(env, 10000, perturbator, corrector)
        
        
        print("reward summ = ", r_summ[-1])

    # closing environment
    
    env.close()
    


        
