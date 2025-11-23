# 📦 Library Installation Guide for D2L.ai Environment

## 🎯 **Recommended Installation Methods**

### **Method 1: Browser JupyterLab** ✅ **EASIEST**

1. **Access JupyterLab**: http://localhost:8888
2. **Open Terminal** in JupyterLab (File → New → Terminal)
3. **Install packages**:
   ```bash
   pip install package-name
   conda install -y package-name
   ```

### **Method 2: Container Terminal** ✅ **MOST RELIABLE**

```bash
# From Windows terminal
docker exec -it mlu-d2l-jupyter-1 bash

# Inside container
pip install package-name
conda install -y package-name
```

### **Method 3: Notebook Cell** ✅ **CONVENIENT**

```python
# In any notebook cell
!pip install package-name

# Or using subprocess (more reliable)
import subprocess
import sys
subprocess.check_call([sys.executable, "-m", "pip", "install", "package-name"])
```

### **Method 4: VS Code with Container** ⚠️ **REQUIRES SETUP**

1. Install VS Code extensions:
   - Docker
   - Remote - Containers
   - Jupyter

2. Attach to container: `Remote Explorer → mlu-d2l-jupyter-1`

3. Install in notebook:
   ```python
   !pip install package-name
   ```

## 🔍 **Pre-installed Packages**

Your D2L.ai container comes with:

### **Core Deep Learning**
- ✅ **PyTorch 2.9.1** (with CUDA 11.8)
- ✅ **D2L 1.0.3** (official library)
- ✅ **TorchVision 0.16.0**
- ✅ **TorchAudio 2.1.0**

### **Data Science**
- ✅ **NumPy 1.23.5**
- ✅ **Pandas 2.0.3**
- ✅ **Matplotlib 3.7.2**
- ✅ **Seaborn 0.13.2**
- ✅ **Scikit-learn 1.7.2**
- ✅ **Plotly 6.5.0**

### **Development Tools**
- ✅ **JupyterLab 4.5.0**
- ✅ **Jupyter Notebook**
- ✅ **Git integration**

### **Korean Language Support**
- ✅ **KoNLPy** (Korean NLP)
- ✅ **Korean fonts** (Nanum, Noto CJK)
- ✅ **UTF-8 encoding**

## 🚀 **Quick Installation Examples**

### **Install popular ML packages**:
```bash
pip install transformers huggingface-hub datasets
```

### **Install visualization tools**:
```bash
pip install plotly dash streamlit
```

### **Install additional Korean NLP**:
```bash
pip install soynlp kiwipiepy
```

## 🔧 **Verification**

Run this in any notebook cell to verify your setup:

```python
import torch, d2l, numpy, pandas, matplotlib, seaborn, sklearn, plotly
print(f"✅ PyTorch: {torch.__version__} (CUDA: {torch.cuda.is_available()})")
print(f"✅ D2L: {d2l.__version__}")
print("🎉 All packages working!")
```

## 💡 **Best Practices**

1. **Use Browser JupyterLab** for D2L.ai learning
2. **Install in container terminal** for permanent packages
3. **Use notebook cells** for experiment-specific packages
4. **Check compatibility** before installing conflicting packages

## 🔄 **Persistent Installation**

Packages installed in the container **persist automatically** due to:
- Volume mounting: `./data:/workspace/data`
- Restart policy: `restart: always`
- Container persistence across reboots

Your installations survive container restarts and system reboots! 🎉