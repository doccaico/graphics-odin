@echo off

setlocal

set NAME=main
set EXE=%NAME%
set PDB=%NAME%
set SRC=%NAME%

set OPT=
set DEBUG=-debug
set STYLE=
if "%~2"=="-release" (
    set OPT=-o:speed
    set DEBUG=
    set STYLE=-strict-style -vet 
)

odin build %SRC%.odin -file %OPT% %DEBUG% %STYLE% -out:%EXE%.exe -pdb-name:%PDB%.pdb
if %ERRORLEVEL% neq 0 exit /b 1

set ODIN_PATH=
for /f "delims=" %%i in ('odin root') do set "ODIN_PATH=%%i"

if not exist "raylib.dll" (
    if exist "%ODIN_PATH%\vendor\raylib\windows\raylib.dll" (
        copy "%ODIN_PATH%\vendor\raylib\windows\raylib.dll" . 1> nul
        if %ERRORLEVEL% neq 0 exit /b 1
    ) else (
        echo "Please copy raylib.dll from <your_odin_compiler>/vendor/raylib/windows/raylib.dll to the same directory as %EXE%.exe"
        exit /b 1
    )
)

if "%~1"=="run" (
    %EXE%.exe
)

endlocal
