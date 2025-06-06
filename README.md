# SmartDarts 🎯

A reinforcement learning environment built with Godot where agents learn to hit multiple dart targets with optimal mouse movement patterns.

![SmartDarts Environment](images/smartDartsScheme.svg)

## 🎯 Overview

SmartDarts is a learning environment that simulates dart-throwing scenarios where an agent must hit multiple targets in sequence. The project supports both AI agents and human players, making it suitable for:

- **Reinforcement Learning Research**: Training agents to optimize targeting strategies
- **Human-Computer Interaction Studies**: Analyzing human mouse movement patterns
- **Comparative Analysis**: Studying differences between human and AI performance

### Key Features

- 🤖 **AI Agent Training**: Support for REINFORCE algorithm with neural networks
- 👤 **Human Player Mode**: Mouse/pointing device control for human participants
- 📊 **Data Logging**: Comprehensive logging of trajectories and performance metrics
- 🎮 **Godot Integration**: Built on Godot 4.4.1 for smooth real-time simulation
- 🔄 **Flexible Configuration**: Customizable grid sizes, target counts, and hit requirements

## 🎮 How It Works

### Environment Setup
- **Targets**: Multiple targets arranged in a configurable grid (e.g., 2x2, 3x3)
- **Agent/Player**: Starts from various positions and must hit each target
- **Success Criteria**: Each target must be hit H times to complete the episode
- **Time Step**: Actions are generated every 0.008 seconds (125 Hz)

### Agent Behavior
- **Movement**: Generates displacement changes (dx, dy) at each time step
- **Objective**: Minimize time and movement to hit all targets H times
- **Learning**: Uses REINFORCE algorithm to improve performance over episodes

## 🚀 Installation

### Prerequisites
- **Python**: 3.11.5 (tested version)
- **Godot**: 4.4.1
- **Operating System**: Linux (Ubuntu tested), Windows, macOS

### Setup Instructions

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd smartDarts
   ```

2. **Install Python dependencies**:
   ```bash
   pip install -r requirement.txt
   ```

3. **Install Godot 4.4.1**:
   - Download from [Godot official website](https://godotengine.org/download)
   - Ensure Godot is in your system PATH

4. **Verify installation**:
   ```bash
   cd smartdarts/python_scripts
   python corrector.py --help
   ```

## 🏃‍♂️ Quick Start

### Training an AI Agent

```bash
# Navigate to the Python scripts directory
cd smartdarts/python_scripts

# Start training with default REINFORCE algorithm
python corrector.py
```

### Using the Python API

```python
from corrector import ReinforceCorrector

# Configure hyperparameters
kwargs = {
    'learning_rate': 0.001,
    'hidden_size': 128,
    'batch_size': 32,
    # Add other hyperparameters as needed
}

# Create and train the corrector
corrector = ReinforceCorrector(**kwargs)
corrector.train()
```

### Human Player Mode

1. Open the Godot project in `smartdarts/`
2. Run the scene to start human player mode
3. Use your mouse to control the dart and hit targets

## 📁 Project Structure

```
smartDarts/
├── images/                     # Documentation images
├── requirement.txt            # Python dependencies
├── README.md                 # This file
└── smartdarts/               # Main project directory
    ├── addons/               # Godot RL agents addon
    ├── art/                  # Game assets (sprites, textures)
    ├── jupyter/              # Analysis notebooks
    ├── logs/                 # Training and performance logs
    ├── python_scripts/       # Python RL training scripts
    │   ├── corrector.py      # Main training script
    │   ├── deep_stuff.py     # Neural network definitions
    │   ├── user_simulator.py # Human behavior simulation
    │   ├── perturbation.py   # Data augmentation
    │   └── rolloutenv.py     # Environment wrapper
    ├── Scenes/               # Godot scene files
    ├── Scripts/              # GDScript files
    └── video/                # Recorded gameplay videos
```

## 🔧 Configuration

### Environment Parameters
- **Grid Size**: Modify target arrangement (2x2, 3x3, etc.)
- **Hit Requirement (H)**: Number of hits required per target
- **Episode Length**: Maximum steps before episode timeout
- **Starting Positions**: Configurable spawn points for the agent

### Training Parameters
- **Algorithm**: REINFORCE (default), extensible to other RL algorithms
- **Network Architecture**: Configurable hidden layers and activation functions
- **Learning Rate**: Adjustable optimization parameters
- **Batch Size**: Episode batch processing configuration

## 📊 Monitoring and Analysis

### Logs
- Training logs are saved in `smartdarts/logs/`
- Human gameplay logs for comparison studies
- Performance metrics and trajectory data

### Visualization
- Jupyter notebooks in `smartdarts/jupyter/` for data analysis
- Video recordings of training progress in `smartdarts/video/`
- Real-time training monitoring through console output

## 🤝 Contributing

We welcome contributions! Please consider:

1. **New RL Algorithms**: Implement additional reinforcement learning methods
2. **Environment Variations**: Create new target configurations or game modes
3. **Analysis Tools**: Develop better visualization and analysis capabilities
4. **Performance Optimization**: Improve training speed and efficiency

## 📚 References and Inspiration

- [Godot RL Agents](https://github.com/edbeeching/godot_rl_agents) - Core RL integration
- [Hugging Face Deep RL Course](https://huggingface.co/learn/deep-rl-course/unitbonus3/godotrl) - Educational resources
- [REINFORCE Algorithm](https://paperswithcode.com/method/reinforce) - Implementation reference

## 📄 License

See the `LICENSE` file in the `smartdarts/` directory for license information.

## 🆘 Support

If you encounter issues:

1. Check the logs in `smartdarts/logs/` for error messages
2. Verify your Python and Godot versions match the requirements
3. Ensure all dependencies are properly installed
4. Create an issue with detailed error descriptions and system information

---

**Happy Dart Throwing! 🎯**
