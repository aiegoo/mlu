# VS Code + D2L.ai Container Setup Guide

## 🚀 Quick Setup

### 1. Install Required VS Code Extensions
- **Docker** (ms-azuretools.vscode-docker)
- **Remote - Containers** (ms-vscode-remote.remote-containers)  
- **Jupyter** (ms-toolsai.jupyter)
- **Python** (ms-python.python)

### 2. Connect VS Code to D2L.ai Container

#### Method 1: Remote Explorer
1. Open **Remote Explorer** (Ctrl+Shift+P → "Remote Explorer")
2. Under **Containers** → Find `mlu-d2l-jupyter-1`
3. Click **Attach to Container**

#### Method 2: Command Palette
1. **Ctrl+Shift+P** → "Remote-Containers: Attach to Running Container"
2. Select `mlu-d2l-jupyter-1`

### 3. Open Workspace in Container
```
File → Open Folder → /workspace/
```

### 4. Select Python Interpreter
1. **Ctrl+Shift+P** → "Python: Select Interpreter"
2. Choose: `/opt/conda/bin/python`

## 📝 **Creating Notebooks in VS Code**

### New Notebook:
1. **Ctrl+Shift+P** → "Jupyter: Create New Jupyter Notebook"
2. **Select Kernel** → Choose container Python interpreter
3. Start coding with full D2L.ai environment!

## 🎯 **Kernel Information**

**Container Python Details:**
- **Path**: `/opt/conda/bin/python`
- **Version**: Python 3.10+
- **Packages**: PyTorch, D2L, Korean NLP, all dependencies
- **GPU**: CUDA acceleration available
- **Location**: Inside mlu-d2l-jupyter-1 container

## ✅ **Verification**

Test your setup with this code:
```python
import torch
import d2l
import sys

print(f"Python: {sys.version}")
print(f"PyTorch: {torch.__version__}")
print(f"CUDA available: {torch.cuda.is_available()}")
print(f"D2L version: {d2l.__version__}")

# Test Korean support
import konlpy
print("Korean NLP ready!")
```

## 🌐 **Browser vs VS Code**

| Feature | Browser JupyterLab | VS Code |
|---------|-------------------|---------|
| **Setup** | ✅ Immediate | ⚠️ Requires extension setup |
| **D2L.ai Official** | ✅ Perfect compatibility | ✅ Good compatibility |
| **GPU Access** | ✅ Seamless | ✅ Works via container |
| **Korean Support** | ✅ Built-in | ✅ Via container |
| **Code Editing** | ✅ Good | ✅ Excellent |
| **Debugging** | ⚠️ Basic | ✅ Advanced |
| **Git Integration** | ⚠️ Basic | ✅ Excellent |

## 💡 **Recommendation**

**For D2L.ai Learning**: Start with **Browser JupyterLab** (http://localhost:8888)
**For Development**: Use **VS Code attached to container**

Both use the same kernel and environment - choose based on your preference!