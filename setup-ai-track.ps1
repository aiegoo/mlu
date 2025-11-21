# AI-Track Directory Setup Script
# Run this to create the proper directory structure for ai-track

$aiTrackPath = "D:\repos\tonylee\goorm\ai-track"

Write-Host "🏗️ Setting up AI-Track directory structure..." -ForegroundColor Green

# Create main directories
$directories = @(
    "$aiTrackPath",
    "$aiTrackPath\d2l-official", 
    "$aiTrackPath\projects",
    "$aiTrackPath\projects\computer-vision",
    "$aiTrackPath\projects\nlp", 
    "$aiTrackPath\projects\reinforcement-learning",
    "$aiTrackPath\projects\research",
    "$aiTrackPath\datasets",
    "$aiTrackPath\experiments", 
    "$aiTrackPath\models"
)

foreach ($dir in $directories) {
    if (!(Test-Path $dir)) {
        New-Item -ItemType Directory -Force -Path $dir
        Write-Host "✅ Created: $dir" -ForegroundColor Cyan
    } else {
        Write-Host "📁 Exists: $dir" -ForegroundColor Yellow
    }
}

# Create environment file if it doesn't exist
$envFile = "$aiTrackPath\.env"
if (!(Test-Path $envFile)) {
    Write-Host "📝 Creating environment file template..." -ForegroundColor Green
    Copy-Item ".\.env.example" $envFile
    Write-Host "✅ Created: $envFile" -ForegroundColor Cyan
    Write-Host "⚠️  Please edit $envFile and add your API credentials" -ForegroundColor Yellow
} else {
    Write-Host "📄 Environment file already exists" -ForegroundColor Yellow
}

# Create a README for ai-track
$readmeContent = @"
# AI-Track Learning Environment

## Directory Structure
- **d2l-official/** - Official d2l.ai notebooks (auto-cloned)
- **projects/** - Your AI projects organized by domain
  - computer-vision/
  - nlp/ 
  - reinforcement-learning/
  - research/
- **datasets/** - Shared datasets
- **experiments/** - Experiment tracking and results
- **models/** - Saved model files

## Environment File
Edit `.env` to add your API credentials:
- OpenAI API Key
- HuggingFace Token
- GitHub Token
- Notion API Token
- AWS/Azure credentials

## Getting Started
1. Run the Docker environment from MLU project
2. Navigate to ai-track in JupyterLab
3. Start with d2l-official notebooks
4. Create projects in the projects/ folder
"@

$readmePath = "$aiTrackPath\README.md"
if (!(Test-Path $readmePath)) {
    Set-Content -Path $readmePath -Value $readmeContent
    Write-Host "✅ Created: $readmePath" -ForegroundColor Cyan
}

Write-Host "`n🎯 AI-Track setup complete!" -ForegroundColor Green
Write-Host "📍 Location: $aiTrackPath" -ForegroundColor Cyan
Write-Host "📝 Next: Edit $envFile with your API credentials" -ForegroundColor Yellow