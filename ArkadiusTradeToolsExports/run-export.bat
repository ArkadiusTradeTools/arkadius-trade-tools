@ECHO OFF

REM Script from https://blog.danskingdom.com/allow-others-to-run-your-powershell-scripts-from-a-batch-file-they-will-love-you-for-it/
SET ThisScriptsDirectory=%~dp0
SET PowerShellScriptPath=%ThisScriptsDirectory%run-export.ps1
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '%PowerShellScriptPath%' %*";