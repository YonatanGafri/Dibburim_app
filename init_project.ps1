# Dibburim App — First-Time Project Initialization
#
# Run this script ONCE after installing Flutter SDK (see SETUP_GUIDE.md).
# It will:
#   1. Initialize the Flutter framework files in this directory
#   2. Install all dependencies
#   3. Verify the project is ready to run
#
# Usage (from PowerShell in the project directory):
#   .\init_project.ps1

Write-Host "🕊️  Initializing Dibburim App..." -ForegroundColor Cyan

# Step 1: Create Flutter project framework files
# Using --no-overwrite to preserve our existing source code
Write-Host "`n[1/4] Creating Flutter framework files..." -ForegroundColor Yellow
flutter create --org com.diburim --project-name dibburim_app --platforms android --no-overwrite .

# Step 2: Install dependencies
Write-Host "`n[2/4] Installing dependencies..." -ForegroundColor Yellow
flutter pub get

# Step 3: Accept Android licenses (if not already done)
Write-Host "`n[3/4] Checking Android licenses..." -ForegroundColor Yellow
flutter doctor --android-licenses

# Step 4: Verify everything is ready
Write-Host "`n[4/4] Running Flutter Doctor..." -ForegroundColor Yellow
flutter doctor

Write-Host "`n✅ Project initialized! Run 'flutter run' to launch the app." -ForegroundColor Green
Write-Host "   Make sure an Android emulator is running first." -ForegroundColor Gray
