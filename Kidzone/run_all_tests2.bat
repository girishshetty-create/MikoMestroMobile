@echo off
REM ============================================================
REM  Miko App - Combined Test Runner (Windows)
REM  Runs all talent deep-link tests and reports PASS/FAIL status
REM ============================================================

setlocal enabledelayedexpansion

set TEST_DIR=C:\MikoTeam\Mestro\Kidzone
set PASS=0
set FAIL=0
set SKIP=0

echo.
echo ============================================
echo    MIKO APP - TALENT DEEP LINK TEST SUITE
echo ============================================
echo   Started : %DATE% %TIME%
echo   Test dir: %TEST_DIR%
echo.

REM -------------------------------------------------------
REM  Define test files
REM -------------------------------------------------------
set TESTS[0]=1MINUTEINAMUSEUM.yaml
set TESTS[1]=briko.yaml
set TESTS[2]=CityDUNK.yaml
set TESTS[3]=kosmix.yaml

REM -------------------------------------------------------
REM  Run each test
REM -------------------------------------------------------
for /L %%i in (0,1,3) do (
    set YAML=%TEST_DIR%\!TESTS[%%i]!
    set TEST_NAME=!TESTS[%%i]:.yaml=!

    REM Check file exists
    if not exist "!YAML!" (
        echo   [SKIP]  !TEST_NAME!  ^(file not found^)
        set /a SKIP+=1
        set RESULT_%%i=SKIP
    ) else (
        echo   Running: !TEST_NAME! ...

        REM ----- Run the test -----
        "C:\Users\Miko\.maestro\bin\maestro" test "!YAML!" > "%TEMP%\maestro_out_%%i.txt" 2>&1
        set EXIT_CODE=!ERRORLEVEL!
        REM ------------------------

        if !EXIT_CODE! EQU 0 (
            echo   [PASS]  !TEST_NAME!
            set /a PASS+=1
            set RESULT_%%i=PASS
        ) else (
            echo   [FAIL]  !TEST_NAME!
            echo   ------ Output ------
            type "%TEMP%\maestro_out_%%i.txt"
            echo   --------------------
            set /a FAIL+=1
            set RESULT_%%i=FAIL
        )
    )
    echo.
)

REM -------------------------------------------------------
REM  Summary
REM -------------------------------------------------------
set /a TOTAL=PASS+FAIL+SKIP

echo ============================================
echo                  SUMMARY
echo ============================================
for /L %%i in (0,1,3) do (
    set TEST_NAME=!TESTS[%%i]:.yaml=!
    if "!RESULT_%%i!"=="PASS" echo   [PASS]  !TEST_NAME!
    if "!RESULT_%%i!"=="FAIL" echo   [FAIL]  !TEST_NAME!
    if "!RESULT_%%i!"=="SKIP" echo   [SKIP]  !TEST_NAME!
)

echo.
echo   Total  : %TOTAL%
echo   Passed : %PASS%
echo   Failed : %FAIL%
echo   Skipped: %SKIP%
echo   Finished: %DATE% %TIME%
echo ============================================
echo.

REM Exit with error code if any tests failed
if %FAIL% GTR 0 exit /b 1
exit /b 0
