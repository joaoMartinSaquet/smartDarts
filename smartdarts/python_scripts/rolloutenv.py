from godot_rl.core.godot_env import GodotEnv
from gymnasium import spaces
import numpy as np
import controller as ctrl



def rolloutSmartDartEnv(env, Nstep, seed = 0):

    observation, info = env.reset(seed=seed)
    
    # initialize controller
    xinit = np.array(observation[0]["obs"][2:] + [0, 0]) 
    Controller = ctrl.closed_loops(xinit)
    
    perturbator = None
    reward_list = []
    # rolling out env
    for i in range(Nstep):
        # get controller actions and process it (clamp, norm, pert, etc...)
        obs = np.array(observation[0]["obs"])
        move_action, click_action = Controller.step(obs[:2], obs[2:])

        # clamp action to don't have to big displacement
        move_action = np.clip(move_action, -80, 80)

        # add perturbation if there is any
        if perturbator is not None:
            move_action = perturbator(move_action)
        
        # contruct msg to be send to the env
        action = np.insert(move_action, 0 , click_action)
        action = np.array([ action for _ in range(env.num_envs) ])

        # step the env
        observation, reward, done, info, _ = env.step(action)

        print("done , reward = ", done, reward)
        # see how to do this with several env 
        if any(done):
            print("done")
            break

        # update reward list
        reward_list.append(reward)
    
    # Close the environment
    print("nstep", i)
    env.close()
    return np.cumsum(reward_list), reward_list

        


if __name__ == "__main__":
    
    # Initialize the environment
    env = GodotEnv(convert_action_space=True)

    # Run the environment
    r_summ, r_list = rolloutSmartDartEnv(env, 10000)

    print("reward summ = ", r_summ)


        
