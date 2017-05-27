@echo off
color F0
::BatchGotAdmin
:-----------------------------------------------------------------
REM --> 检查权限 
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system" 
REM --> 如果出现了错误，则目前的批处理未以管理员权限运行。 
if '%errorlevel%' NEQ '0' ( 
    goto UACPrompt 
) else ( goto gotAdmin )

:UACPrompt
echo 点击确定，以使得该脚本可以以管理员身份运行
> "%temp%\getadmin.vbs" echo Set UAC = CreateObject^("Shell.Application"^)
>> "%temp%\getadmin.vbs" echo UAC.ShellExecute "%~s0", "", "", "runas", 1
%temp%\getadmin.vbs
exit /B

:gotAdmin
if exist "%temp%\getadmin.vbs"(del "%temp%\getadmin.vbs")

:-----------------------------------------------------------------

:menu
echo 请选择操作类型：
echo 输入1并回车为设置相关服务为手动启动（相关服务仍有可能被触发）。
echo 输入2并回车为设置相关服务为禁止启动（您将无法使用SMB V1的协议进行文件共享）。
echo 直接回车或者关闭差U那个口为退出。
echo 注：除XP和部分WIN7外，大部分机器使用的均为SMB V2协议。
set /p choose=
if %choose%==1 goto demand
if %choose%==2 goto disable

:disable
cls
echo 正在准备为您关闭SMB V1的服务及驱动支持
choice /t 3 /d y /n >nul
echo 正在为您关闭SMB V1的相关服务
net stop srv 2>nul
net stop mrxsmb10 2>nul
echo 正在为您将SMB V1的相关服务调整为禁止启动
sc config srv start=disabled 2>nul
sc config mrxsmb10 start=disabled 2>nul
choice /t 2 /d y /n >nul
echo -------------------------------------------------------
echo 			我是分界线。
echo -------------------------------------------------------
choice /t 2 /d y /n >nul
echo 正在准备为您启用SMB V2的服务及驱动支持
choice /t 3 /d y /n >nul
echo 正在为您打开SMB V2的相关服务
net start srv2 2>nul
net start mrxsmb20 2>nul
echo 正在为您将SMB V2的相关服务调整为自动启动
sc config srv2 start=auto 2>nul
sc config mrxsmb20 start=auto 2>nul
goto exit

:demand
cls
echo 正在准备为您关闭SMB V1的服务及驱动支持
choice /t 3 /d y /n >nul
echo 正在为您关闭SMB V1的相关服务
net stop srv 2>nul
net stop mrxsmb10 2>nul
echo 正在为您将SMB V1的相关服务调整为手动启动
sc config srv start=demand 2>nul
sc config mrxsmb10 start=demand 2>nul
choice /t 2 /d y /n >nul
echo -------------------------------------------------------
echo 			我是分界线。
echo -------------------------------------------------------
choice /t 2 /d y /n >nul
echo 正在准备为您启用SMB V2的服务及驱动支持
choice /t 3 /d y /n >nul
echo 正在为您打开SMB V2的相关服务
net start srv2 2>nul
net start mrxsmb20 2>nul
echo 正在为您将SMB V2的相关服务调整为自动启动
sc config srv2 start=auto 2>nul
sc config mrxsmb20 start=auto 2>nul
goto exit

:exit
choice /t 2 /d y /n >nul
echo -------------------------------------------------------
echo 	  OK！！！所有调整已完成 按任意键退出该窗口
echo -------------------------------------------------------
pause>nul
