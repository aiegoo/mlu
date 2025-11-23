# D2L.ai Auto-Startup Guide

## 🚀 Option 1: Windows Startup Folder (Recommended)

### For immediate startup when Windows boots:

1. **Copy the startup script**:
   ```
   Copy: auto-start-d2l.bat
   To: C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\
   ```

2. **Or use Run dialog**:
   - Press `Win + R`
   - Type: `shell:startup`
   - Copy `auto-start-d2l.bat` to this folder

## 🔧 Option 2: Docker Desktop Auto-Start

### Configure Docker Desktop itself:

1. **Open Docker Desktop Settings**
2. **General Tab** → Enable:
   - ✅ "Start Docker Desktop when you sign in to Windows"
   - ✅ "Use WSL 2 based engine" (if using WSL)

3. **Then add to shell startup**:
   ```bash
   # Add to ~/.bashrc or ~/.zshrc
   source /d/repos/tonylee/goorm/mlu/auto-start-d2l.sh
   ```

## ⚡ Option 3: Task Scheduler (Advanced)

### For more control over startup timing:

1. **Open Task Scheduler** (`taskschd.msc`)
2. **Create Basic Task**:
   - Name: "D2L.ai Auto Start"
   - Trigger: "When I log on"
   - Action: "Start a program"
   - Program: `d:\repos\tonylee\goorm\mlu\auto-start-d2l.bat`

## 🐳 Option 4: Docker Compose Auto-Restart

### Make containers restart automatically:

```yaml
# Add to docker-compose.yml under d2l-jupyter service:
services:
  d2l-jupyter:
    restart: unless-stopped
    # ... other configurations
```

## 🛠️ Quick Setup Commands

### Windows (Run as Administrator):
```cmd
# Copy to startup folder
copy "d:\repos\tonylee\goorm\mlu\auto-start-d2l.bat" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\"

# Make Docker start with Windows
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "DockerDesktop" /t REG_SZ /d "C:\Program Files\Docker\Docker\Docker Desktop.exe"
```

### Linux/WSL:
```bash
# Add to shell startup
echo 'source /d/repos/tonylee/goorm/mlu/auto-start-d2l.sh' >> ~/.bashrc
```

## ✅ Verification

After setup, restart your computer and check:
- Docker Desktop starts automatically
- D2L.ai environment launches
- JupyterLab accessible at http://localhost:8888

## 🔧 Troubleshooting

### If auto-start fails:
1. **Check Docker Desktop is set to start with Windows**
2. **Verify script paths are correct**
3. **Run script manually first to test**
4. **Check Windows Event Viewer for errors**

### Manual start:
```bash
cd d:\repos\tonylee\goorm\mlu
./auto-start-d2l.bat
```

Choose the option that works best for your workflow! 🚀