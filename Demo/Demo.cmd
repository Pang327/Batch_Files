@echo off
setlocal enabledelayedexpansion
color 3e

set /p p=Target(1~5): 

echo %p% | find "1" > nul && echo 1 >> tmp.txt
echo %p% | find "2" > nul && echo 2 >> tmp.txt
echo %p% | find "3" > nul && echo 3 >> tmp.txt
echo %p% | find "4" > nul && echo 4 >> tmp.txt
echo %p% | find "5" > nul && echo 5 >> tmp.txt

for /f %%i in (tmp.txt) do (
    call :label%%i
)
del tmp.txt
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