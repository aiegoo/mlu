# 🔧 VS Code + Docker Container Connection Guide

## 🚨 **Current Issue**
VS Code doesn't show your Docker container (`mlu-d2l-jupyter-1`) as an available kernel option.

## 🎯 **Solution: Connect VS Code to Container**

### **Step 1: Verify Container is Running**
```bash
docker ps --filter "name=mlu-d2l-jupyter"
```
✅ **Expected**: `mlu-d2l-jupyter-1` should be listed as "Up"

### **Step 2: Connect VS Code to Container**

#### **Option A: Remote Explorer (Easiest)**
1. **Open VS Code**
2. **View Menu** → **Remote Explorer** (or `Ctrl+Shift+E`)
3. **Containers Section** → Find `mlu-d2l-jupyter-1`
4. **Right-click** → **"Attach to Container"**
5. **New Window Opens** → Now you're inside the container!

#### **Option B: Command Palette**
1. **Press** `Ctrl+Shift+P` (Windows) or `Cmd+Shift+P` (Mac)
2. **Type**: `Dev Containers: Attach to Running Container`
3. **Select**: `mlu-d2l-jupyter-1`
4. **Wait** for VS Code to connect (may take 1-2 minutes)

### **Step 3: Open Notebook in Connected VS Code**

Once connected to the container:
1. **File** → **Open Folder** → `/workspace`
2. **Navigate to**: `/workspace/01_foundations/`
3. **Open**: `week1_d2l_official_roadmap.ipynb`

### **Step 4: Select Python Interpreter**

When prompted to select kernel:
1. **Click** "Select Kernel" in the notebook
2. **Choose** "Python Environments"
3. **Select**: `/opt/conda/bin/python` 
   - This is the container's Python with all packages

## 🔍 **Troubleshooting**

### **Problem**: Can't see containers in Remote Explorer
**Solution**: 
1. Install "Dev Containers" extension: `ms-vscode-remote.remote-containers`
2. Restart VS Code
3. Check Docker Desktop is running

### **Problem**: "Attach to Container" not working
**Solution**:
```bash
# Restart Docker container
docker restart mlu-d2l-jupyter-1

# Verify it's running
docker ps
```

### **Problem**: Python interpreter not found
**Solution**: 
- Use exact path: `/opt/conda/bin/python`
- Or try: `/usr/local/bin/python`

## 🎯 **Alternative: Browser JupyterLab (Recommended)**

If VS Code connection is problematic:
1. **Open Browser**: http://localhost:8888
2. **Use JupyterLab**: Full-featured, no setup required
3. **All packages work**: Same environment, zero configuration

## ✅ **Verification**

Test your setup with this code in any cell:
```python
import sys, torch, d2l
print(f"Python: {sys.executable}")
print(f"PyTorch: {torch.__version__}")
print(f"D2L: {d2l.__version__}")
print(f"CUDA: {torch.cuda.is_available()}")
```

## 🎉 **Success Indicators**

You're connected successfully when:
- ✅ Python path shows `/opt/conda/bin/python`
- ✅ CUDA available = True
- ✅ D2L library imports without errors
- ✅ Korean language support works

---

**💡 Recommendation**: Use Browser JupyterLab (http://localhost:8888) for D2L.ai learning - it's simpler and guaranteed to work!