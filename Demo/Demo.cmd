@echo off
setlocal enabledelayedexpansion
color 3e

set choice=
set /p p=Target(1~5): 

echo %p% | find "1" > nul && set choice=%choice% 1
echo %p% | find "2" > nul && set choice=%choice% 2
echo %p% | find "3" > nul && set choice=%choice% 3
echo %p% | find "4" > nul && set choice=%choice% 4
echo %p% | find "5" > nul && set choice=%choice% 5

for %%i in (%choice%) do (
    call :label%%i
)
goto end

:label1
echo label1
goto :EOF

:label2
echo label2
goto :EOF

:label3
echo label3
goto :EOF

:label4
echo label4
goto :EOF

:label5
echo label5
goto :EOF

:end
echo.
echo Press any key to close...
pause > nul