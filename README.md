# SmartDarts

## Objective

The goal of this project is to create a learning environment where an agent attempts to reach multiple targets. For each targets, we draw multiple starting position for the agent. Where the agent is either a simulated players, that has is own dynamics or a human that control the position of the darts using is mouse or any pointing device. 
The goal for the agent is to try from his starting position to reach the targets and click on it, for each target he needs to reach it \(H\) times, and for \(C  \times R \), an episode is ended whenever the agent succeed to click on all targets

![alt text](images/smartDartsScheme.svg)

## Agent Behavior
To Change the darts positions, we need to generate a displacement at each sample (0.008sec for a classical mouse). 
- **Movement**: The agent will try to generate changes in its \( x \) and \( y \) coordinates (\( dx \) and \( dy \)) at each time interval.
- **Goal**: The agent aims to reach each target H times sequentially.
  
## Installation
Tested and developped with : 
- python 3.11.5
- Godot 4.4.1
  
See requirement.txt for packages


# sources 
- https://github.com/edbeeching/godot_rl_agents
- https://huggingface.co/learn/deep-rl-course/unitbonus3/godotrl
  