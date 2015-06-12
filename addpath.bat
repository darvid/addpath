:: addpath.bat
:: ~~~~~~~~~~~
::
:: Batch script that installs itself as a shell context menu handler, allowing
:: for the quick addition of directories to the global PATH environment
:: variable.
::
:: Usage
:: ~~~~~
::
:: To install the shell extension, simply run this batch file as administrator.
:: To add a directory to the system PATH, simply right-click it in explorer and
:: select 'Add to PATH.'
@echo off
if "%~1"=="" goto install
goto checkuac

:install
echo Installing shell extension
reg add HKLM\SOFTWARE\Classes\Folder\shell\addpath /d "Add to PATH" /f
reg add HKLM\SOFTWARE\Classes\Folder\shell\addpath\command /d "%~0 ""%%1""" /f
pause
exit

:addpath
pushd "%CD%"
cd /D "%~dp0"
echo %PATH% | findstr /C:";%~1">nul && (
    echo %~1 already in PATH
) || (
    setx PATH "%PATH%;%~1" /M
)
exit

:checkuac
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto uacprompt
)
goto addpath

:uacprompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
set params = %*:"=""
echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params% ""%~1""", "", "runas", 1 >> "%temp%\getadmin.vbs"

"%temp%\getadmin.vbs"
del "%temp%\getadmin.vbs"
exit /B