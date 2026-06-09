$ErrorActionPreference = 'Stop'

Write-Host 'SENTRA Android preflight checks...' -ForegroundColor Cyan

$projectRoot = Split-Path -Parent $PSScriptRoot
$gradlePropsPath = Join-Path $projectRoot 'android\gradle.properties'
$localPropsPath = Join-Path $projectRoot 'android\local.properties'

if (-not (Test-Path $gradlePropsPath)) {
  throw "Missing file: $gradlePropsPath"
}

if (-not (Test-Path $localPropsPath)) {
  throw "Missing file: $localPropsPath"
}

$gradleProps = Get-Content $gradlePropsPath -Raw
$javaHomePinned = $gradleProps -match 'org\.gradle\.java\.home\s*=\s*(.+)'
if (-not $javaHomePinned) {
  Write-Warning 'org.gradle.java.home is not set in android/gradle.properties'
} else {
  $configuredJavaHome = $matches[1].Trim() -replace '\\\\', '\'
  if ($configuredJavaHome -ne 'C:\SDK\jdk-17') {
    Write-Warning 'org.gradle.java.home is not pinned to C:\SDK\jdk-17 in android/gradle.properties'
  }
}

$localProps = Get-Content $localPropsPath -Raw
if ($localProps -notmatch 'sdk\.dir=(.+)') {
  throw 'android/local.properties does not contain sdk.dir'
}

$sdkDir = ($matches[1] -replace '\\\\', '\')
if (-not (Test-Path $sdkDir)) {
  throw "Android SDK path not found: $sdkDir"
}

$platform35 = Join-Path $sdkDir 'platforms\android-35'
if (-not (Test-Path $platform35)) {
  throw 'Android SDK Platform 35 is not installed.'
}

$buildToolsRoot = Join-Path $sdkDir 'build-tools'
if (-not (Test-Path $buildToolsRoot)) {
  throw 'Android build-tools directory not found.'
}

$stderrFile = Join-Path $env:TEMP 'sentra-java-version.err.txt'
$stdoutFile = Join-Path $env:TEMP 'sentra-java-version.out.txt'

if (Test-Path $stderrFile) {
  Remove-Item $stderrFile -Force
}
if (Test-Path $stdoutFile) {
  Remove-Item $stdoutFile -Force
}

$process = Start-Process -FilePath 'java' -ArgumentList '-version' -NoNewWindow -PassThru -Wait -RedirectStandardOutput $stdoutFile -RedirectStandardError $stderrFile
if ($process.ExitCode -ne 0) {
  throw 'Java is not available on PATH.'
}

$javaVersion = @()
if (Test-Path $stdoutFile) {
  $javaVersion += Get-Content $stdoutFile
}
if (Test-Path $stderrFile) {
  $javaVersion += Get-Content $stderrFile
}

Write-Host "Java version:`n$javaVersion" -ForegroundColor Gray
Write-Host 'Preflight checks passed.' -ForegroundColor Green
Write-Host 'Run: flutter.bat build apk --release' -ForegroundColor Green
