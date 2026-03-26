@echo off
setlocal enabledelayedexpansion

set MAESTRO=C:\Users\Miko\.maestro\bin\maestro
set TEST_DIR=C:\MikoTeam\Mestro\Kidzone
set PASS=0
set FAIL=0

echo.
echo ============================================
echo    MIKO APP - TALENT DEEP LINK TEST SUITE
echo ============================================
echo   Started : %DATE% %TIME%
echo.

REM -------------------------------------------------------
call :run_test "1MINUTEINAMUSEUM.yaml"
call :run_test "briko.yaml"
call :run_test "CityDUNK.yaml"
call :run_test "kosmix.yaml"
REM -------------------------------------------------------

set /a TOTAL=PASS+FAIL

echo.
echo ============================================
echo                  SUMMARY
echo ============================================
echo   %R1%
echo   %R2%
echo   %R3%
echo   %R4%
echo.
echo   Total  : %TOTAL%
echo   Passed : %PASS%
echo   Failed : %FAIL%
echo   Finished: %DATE% %TIME%
echo ============================================
echo.

if %FAIL% GTR 0 exit /b 1
exit /b 0


REM -------------------------------------------------------
:run_test
set YAML_FILE=%~1
set TEST_NAME=%YAML_FILE:.yaml=%
set FULL_PATH=%TEST_DIR%\%YAML_FILE%

echo   Running: %TEST_NAME% ...

if not exist "%FULL_PATH%" (
    echo   [SKIP]  %TEST_NAME%  ^(file not found^)
    goto :eof
)

"%MAESTRO%" test "%FULL_PATH%" > "%TEMP%\maestro_out.txt" 2>&1
set ERR=%ERRORLEVEL%

if %ERR% EQU 0 (
    echo   [PASS]  %TEST_NAME%
    set /a PASS+=1
    if not defined R1 (set R1=[PASS]  %TEST_NAME%) else if not defined R2 (set R2=[PASS]  %TEST_NAME%) else if not defined R3 (set R3=[PASS]  %TEST_NAME%) else (set R4=[PASS]  %TEST_NAME%)
) else (
    echo   [FAIL]  %TEST_NAME%
    echo   ------ Output ------
    type "%TEMP%\maestro_out.txt"
    echo   --------------------
    set /a FAIL+=1
    if not defined R1 (set R1=[FAIL]  %TEST_NAME%) else if not defined R2 (set R2=[FAIL]  %TEST_NAME%) else if not defined R3 (set R3=[FAIL]  %TEST_NAME%) else (set R4=[FAIL]  %TEST_NAME%)
)
echo.
goto :eof
