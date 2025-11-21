# 🐳 D2L.ai Containerized Learning Environment

## 🚀 Quick Start

### 1. Setup AI-Track Directory (First Time Only)
```powershell
# Run this PowerShell script to create the directory structure
.\setup-ai-track.ps1
```

### 2. Configure Environment File
```bash
# Copy the example and edit with your credentials
cp .env.example D:/repos/tonylee/goorm/ai-track/.env
# Edit the .env file with your API keys (OpenAI, HuggingFace, GitHub, Notion, etc.)
```

### 3. Launch Environment
```bash
# Windows
.\start-docker-d2l.bat

# Linux/macOS/WSL
.\start-docker-d2l.sh
```

Access JupyterLab at: **http://localhost:8888** (no password required)

## 🌐 Language & GPU Support

### 🌏 Korean Language Support
- **UTF-8 Encoding** - Full Korean text support
- **Korean Fonts** - Nanum, Noto CJK fonts installed
- **Korean NLP Libraries**:
  - **KoNLPy** - Korean morphological analysis
  - **soynlp** - Unsupervised Korean NLP
  - **Kiwipiepy** - Fast Korean morphological analyzer

### 🔥 GPU Support
- **NVIDIA Runtime** - Full GPU acceleration
- **CUDA 11.8** - Compatible with RTX 30/40 series
- **PyTorch GPU** - Automatic GPU detection
- **Memory Optimization** - Efficient VRAM usage

### 🔑 API Credentials
The environment loads credentials from `D:/repos/tonylee/goorm/ai-track/.env`:
- **OpenAI** - GPT models and embeddings
- **HuggingFace** - Transformers and datasets
- **GitHub** - Repository access
- **Notion** - Note taking and knowledge base
- **AWS/Azure** - Cloud AI services

## 📂 Directory Structure

```
/workspace/
├── mlu/                          # Your current MLU project
├── ai-track/                     # Mapped to D:/repos/tonylee/goorm/ai-track/
│   ├── .env                      # 🔑 Your API credentials
│   ├── d2l-official/            # 📚 Official d2l.ai notebooks (cloned from GitHub)
│   │   └── d2l-en/              # Complete d2l.ai English version
│   ├── projects/                # 🚀 Your AI projects
│   │   ├── computer-vision/
│   │   ├── nlp/
│   │   ├── reinforcement-learning/
│   │   └── research/
│   ├── datasets/                # 📊 Shared datasets
│   ├── experiments/             # 🧪 Experiment tracking
│   └── models/                  # 💾 Saved models
```

## 🎯 Learning Workflow

### 1. **Official D2L.ai Content**
```
/workspace/ai-track/d2l-official/d2l-en/
├── chapter_introduction/
├── chapter_preliminaries/
├── chapter_linear-regression/
├── chapter_multilayer-perceptrons/
├── chapter_convolutional-neural-networks/
└── ... (all 22 chapters)
```

### 2. **Project Domains**
Switch between AI domains easily:

- **Computer Vision**: `/workspace/ai-track/projects/computer-vision/`
- **NLP**: `/workspace/ai-track/projects/nlp/`
- **Reinforcement Learning**: `/workspace/ai-track/projects/reinforcement-learning/`
- **Research**: `/workspace/ai-track/projects/research/`

## 🛠️ Docker Commands

```bash
# Start environment
docker-compose up -d

# View logs
docker-compose logs -f

# Restart
./docker-restart.sh

# Stop environment
docker-compose stop

# Stop and remove containers
docker-compose down

# Access container shell
docker-compose exec d2l-jupyter bash
```

## 📚 What's Included

- **PyTorch 2.1+** with CUDA 11.8 support
- **D2L Library 1.0.3** - Official d2l.ai package
- **JupyterLab 4.0+** - Modern notebook interface
- **Official D2L Notebooks** - Cloned directly from GitHub
- **Scientific Stack** - NumPy, Pandas, Matplotlib, Seaborn
- **ML Libraries** - Scikit-learn, SciPy
- **Korean NLP** - KoNLPy, soynlp, kiwipiepy
- **AI APIs** - OpenAI, HuggingFace, transformers
- **No Password Required** - Immediate access

## 🔗 Key Features

✅ **Authentic Experience** - Uses official d2l.ai repository  
✅ **Domain Switching** - Easy navigation between AI fields  
✅ **Persistent Storage** - Your work is saved between restarts  
✅ **CUDA Ready** - GPU acceleration for training  
✅ **Isolated Environment** - No conflicts with host system  
✅ **Auto-sync** - MLU project automatically mounted  

## 🎯 Getting Started

1. **Launch**: Run `./start-docker-d2l.bat`
2. **Open**: http://localhost:8888
3. **Navigate**: Go to `ai-track/d2l-official/d2l-en/`
4. **Learn**: Follow Chapter 1 → Chapter 2 → etc.
5. **Experiment**: Create projects in `ai-track/projects/`

This setup gives you the **authentic d2l.ai learning experience** with easy domain switching!