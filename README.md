# SmartDarts 🎯

A reinforcement learning environment built with Godot where agents learn to hit multiple dart targets with optimal mouse movement patterns.

![SmartDarts Environment](images/smartDartsScheme.svg)

## 🎯 Overview

SmartDarts is a learning environment that simulates dart-throwing scenarios where an agent must hit multiple targets in sequence. 

### Key Features

- 🎮 **Godot Environment**: Built on Godot 4.4.1 for smooth real-time simulation
- 👤 **Human Player Mode**: Mouse/pointing device control for human participants
- 📊 **Data Logging**: Comprehensive logging of trajectories and performance metrics
- 🔄 **Flexible Configuration**: Customizable grid sizes, target counts, and hit requirements
- 🤖 **AI Agent Training**: Available in separate [SmartDartCorrector](https://github.com/joaoMartinSaquet/SmartDartCorrector) repository

## 🎮 How It Works

### Environment Setup
- **Targets**: Multiple targets arranged in a configurable grid (e.g., 2x2, 3x3)
- **Agent/Player**: Starts from various positions and must hit each target
- **Success Criteria**: Each target must be hit H times to complete the episode
- **Time Step**: Actions are generated every 0.008 seconds (125 Hz)



## 🚀 Installation

### Prerequisites
- **Godot**: 4.4.1
- **Operating System**: Linux (Ubuntu tested), Windows, macOS
- **Python**: 3.11.5 (for AI training - see separate repository)

### Setup Instructions

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd smartDarts
   ```

2. **Install Godot 4.4.1**:
   - Download from [Godot official website](https://godotengine.org/download)
   - Ensure Godot is in your system PATH

3. **For AI Training** (optional):
   - Clone the [SmartDartCorrector](https://github.com/joaoMartinSaquet/SmartDartCorrector) repository
   - Follow the setup instructions in that repository

## 🏃‍♂️ Quick Start

### Human Player Mode

1. Open the Godot project in the root directory
2. Run the scene to start human player mode
3. Use your mouse to control the dart and hit targets



## 📁 Project Structure

```
smartDarts/
├── addons/                   # Godot RL agents addon
├── art/                      # Game assets (sprites, textures)
├── images/                   # Documentation images
├── jupyter/                  # Analysis notebooks and visualizations
│   ├── images/              # Generated plots and charts
│   └── viz.ipynb           # Main visualization notebook
├── logs/                     # Training and performance logs
├── Scenes/                   # Godot scene files
├── Scripts/                  # GDScript files
├── smartdarts/              # Core game logic
├── video/                    # Recorded gameplay videos
├── requirement.txt           # Python dependencies
└── README.md                # This file
```

### AI Training Components (Separate Repository)

The Python RL training scripts have been moved to: **[SmartDartCorrector](https://github.com/joaoMartinSaquet/SmartDartCorrector)**

- `corrector.py` - Main training script
- `deep_stuff.py` - Neural network definitions  
- `user_simulator.py` - Human behavior simulation
- `perturbation.py` - Data augmentation
- `rolloutenv.py` - Environment wrapper
- Training logs and saved models

## 🔧 Configuration

### Environment Parameters
- **Grid Size**: Modify target arrangement (2x2, 3x3, etc.)
- **Hit Requirement (H)**: Number of hits required per target
- **Episode Length**: Maximum steps before episode timeout
- **Starting Positions**: Configurable spawn points for the agent

## 📊 Monitoring and Analysis

### Logs
- Human gameplay logs for comparison studies
- Performance metrics and trajectory data

### Visualization
- Jupyter notebooks in `jupyter/` for data analysis
- Generated plots and visualizations in `jupyter/images/`
- Video recordings of gameplay in `video/`
- Real-time training monitoring available in AI training repository


## 📚 References and Inspiration

- [Godot RL Agents](https://github.com/edbeeching/godot_rl_agents) - Core RL integration
- [Hugging Face Deep RL Course](https://huggingface.co/learn/deep-rl-course/unitbonus3/godotrl) - Educational resources
- [REINFORCE Algorithm](https://paperswithcode.com/method/reinforce) - Implementation reference

## 📄 License

See the `LICENSE` file in the project directory for license information.

## 🆘 Support

If you encounter issues:

1. Check the logs in `logs/` or `python_scripts/logs_corrector/` for error messages
2. Verify your Python and Godot versions match the requirements
3. Ensure all dependencies are properly installed
4. Create an issue with detailed error descriptions and system information

---

**Happy Dart Throwing! 🎯**
