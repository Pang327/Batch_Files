@echo off
setlocal enabledelayedexpansion 

title LocalizeCopyTool

set tool_path=D:\ECT_Project_TestTool

set src_path=F:\WinDrv_Src\IT5_Color_v3.0\KMSrc_2.06.31\Driver


for /d %%i in (%tool_path%\*) do (
    echo %%~ni | find "-" > nul
    if not errorlevel 1 (
        ::GEN FA
        echo %%~ni | find "FA" > nul
        if not errorlevel 1 (
            ::GEN PRT
            set machineGF_T=%%~ni) else (
            set machineG_T=%%~ni
        )
    ) else (
        echo %%~ni | find "FA" > nul
        if not errorlevel 1 (
            ::OWN FA
            set machineOF_T=%%~ni) else (
            ::NOT PKI
            echo %%~ni | find "PKI" > nul
            if not errorlevel 1 (
                ::OWN PRT PKI
                set machineP_T=%%~ni) else (
                ::EXCLUDE SCCopy folder
                echo %%~ni | find "SCCopy" > nul
                if errorlevel 1 (
                    ::OWN PRT 
                    set machineO_T=%%~ni
                )
            )
        )
    )   
)


for /d %%i in (%src_path%\Model\*) do (
    echo %%~ni | find "-" > nul
    if not errorlevel 1 (
        
        echo %%~ni | find "FA" > nul
        if not errorlevel 1 (
            
            set machineGF_S=%%~ni) else (
            set machineG_S=%%~ni
        )
    ) else (
        echo %%~ni | find "FA" > nul
        if not errorlevel 1 (
            
            set machineOF_S=%%~ni) else (
            
            echo %%~ni | find "PKI" > nul
            if not errorlevel 1 (
                set machineP_S=%%~ni) else (
                set machineO_S=%%~ni
            )
        )
    )
)

:choice
set /a n=0
set PDL_NB1=
set PDL_NB2=
set PDL_NB3=
set PDL_NB4=
set PDL_NB5=

echo following available types, choice number:
if "%machineGF_T%"=="%machineGF_S%" (set /a n+=1 && set PDL_NB1=!n!.%machineGF_S%)
if "%machineG_T%"=="%machineG_S%" (set /a n+=1 && set PDL_NB2=!n!.%machineG_S%)
if "%machineOF_T%"=="%machineOF_S%" (set /a n+=1 && set PDL_NB3=!n!.%machineOF_S%)
if "%machineO_T%"=="%machineO_S%" (set /a n+=1 && set PDL_NB4=!n!.%machineO_S%)
if "%machineP_T%"=="%machineP_S%" (set /a n+=1 && set PDL_NB5=!n!.%machineP_S%)

set PDL_NB=%PDL_NB1% %PDL_NB2% %PDL_NB3% %PDL_NB4% %PDL_NB5%
echo %PDL_NB%
set /p input=


for %%i in (%PDL_NB%) do call :pickup %%i 
goto :eof

:pickup 
set stl=%1

::avoid input string is null, exception handling
if "%stl%"=="" goto :eof

if "%stl:~0,1%"=="%input:~0,1%" (
    echo %stl%
    echo %stl% | find "-" > nul
    if not errorlevel 1 (
        echo %stl% | find "FA" > nul
        if not errorlevel 1 (
            set input=%input:~1% && echo genfax) else (
            set input=%input:~1% && echo gen
        )
    ) else (
        echo %stl% | find "FA" > nul
        if not errorlevel 1 (
            set input=%input:~1% && echo ownfax) else (
            echo %stl% | find "PKI" > nul
            if not errorlevel 1 (
                set input=%input:~1% && echo pki) else (
                set input=%input:~1% && echo own
            )
        )
    )
)
    
goto :eof 