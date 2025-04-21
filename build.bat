@echo off

:: === Configurable Variables ===
set BUILD_DIR=build
set GAME_SOURCE=%1.c

:: Capture current date and time for log file name
for /f "tokens=1-4 delims=/ " %%a in ("%DATE%") do set TODAY=%%c-%%a-%%b
for /f "tokens=1-2 delims=:." %%a in ("%TIME%") do set CURTIME=%%a-%%b

:: Replace any invalid characters (like colon ":") with valid ones in time
set CURTIME=%CURTIME: =%
set CURTIME=%CURTIME::=-%

:: Set the verbose level
set "VERBOSE="
if "%~2"=="-v" (
    set "VERBOSE=-v"
)

set MINGW_INCLUDE=C:\mingw64\include
set RAYLIB_INCLUDE=..\raylib_win\include
set RAYLIB_LIB=..\raylib_win\lib\

:: === Create Build Directory and Clear Log ===
mkdir %BUILD_DIR% 2>nul

:: Create a unique log file name using date and time
set LOG_FILE=%BUILD_DIR%\build_log_%TODAY%_%CURTIME%.txt

:: Log start time
echo [%TIME%] Build Started
echo ===== Build started at %TIME% ===== >> %LOG_FILE%

:: === Final Compilation ===
:CompileGame
echo [%TIME%] Compiling executable...
pushd %BUILD_DIR%
g++ %VERBOSE% -Wall -I%MINGW_INCLUDE% -I%RAYLIB_INCLUDE% ..\%GAME_SOURCE% -L%RAYLIB_LIB% -lraylib -lopengl32 -lgdi32 -lwinmm -o %1.exe >> ..\%LOG_FILE% 2>&1
if errorlevel 1 (GOTO BuildFailed)
if errorlevel 0 (echo    +++ 0 Errors +++ >> ..\%LOG_FILE%)
popd

echo ===== Build completed at %TIME% =====>> %LOG_FILE%
echo [%TIME%] Build Successful
exit /b

:: === Build Failed ===
:BuildFailed
echo ===== Build failed at %TIME% =====>> %LOG_FILE%
echo [%TIME%] Build Failed
exit /b