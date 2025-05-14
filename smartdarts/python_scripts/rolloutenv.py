from godot_rl.core.godot_env import GodotEnv
from gymnasium import spaces
import numpy as np
import controller as ctrl


if __name__ == "__main__":
    
    # Initialize the environment
    env = GodotEnv(convert_action_space=True)
    # print("observation space", env.observation_space)
    # print("action space", env.action_space)
    Nstep = 100000
    print("num env : ", env.num_envs)
    print(env.action_space_processor._convert)
    observation, _ = env.reset(seed=0)
    print("observation space", observation[0]["obs"])
    xinit = np.array(observation[0]["obs"][2:] + [0, 0]) 
    ctrl = ctrl.closed_loops(xinit)
    click_action = 0
    for i in range(Nstep):
        action = env.action_space.sample()

        obs = np.array(observation[0]["obs"])
        
        # constuct actions 
        move_action, click_action = ctrl.step(obs[:2], obs[2:])[0:2]

        
        # ensure that actions is not out of theoritical max
        move_action =  np.clip(move_action, -80, 80)
        action = np.insert(move_action, 0 , click_action)
        
        action = np.array([ action for _ in range(env.num_envs) ])
        observation, reward, done, info, _ = env.step(action)
        
    env.close()