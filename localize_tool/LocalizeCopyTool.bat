@echo on
setlocal enabledelayedexpansion 

title LocalizeCopyTool

:tool
cls
set tool_path=
echo *************************************************************
echo 1.Input created Localize folder path in tool.(copy from)
echo.
echo sample:E:\Zeus-S_ECT_Project
echo *************************************************************
set tool_path=D:\ECT_Project_TestTool
::set tool_path=D:\ECT_Project
::set  /p tool_path=Drag folder here:


if "%tool_path%"=="" (echo Please Re-enter Path After Press Any Button. & pause>nul && goto tool)

:src
cls
set src_path=
echo *************************************************************
echo 2.Input target Localize folder path in source.(copy to)
echo.
echo sample:F:\WinDrv_Src\IT5_Color_v3.0\KMSrc_2.06.34\Driver
echo *************************************************************
set src_path=E:\TEST
::set src_path=F:\WinDrv_Src\IT5_Color_v3.0\KMSrc_2.06.31\Driver
::set  /p src_path=Drag folder here:

if "%src_path%"=="" (echo Please Re-enter Path After Press Any Button. & pause>nul && goto src)

:cfr
cls
echo *************************************************************
echo 3. Confirm your setting
echo.
echo Copy from: %tool_path%
echo Copy to:   %src_path%
echo *************************************************************
echo Press [Y/y] to execute, press [N/n] to reset:
choice
:: after "choice" command, if Y/y errorlevel==1, if N/n errorlevel==2
if errorlevel 2 (goto tool)


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


::for /d %%i in (%src_path%\Model\*) do (
for /d %%i in (%src_path%\*) do (
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
if "%input%"=="" goto :eof
if "%stl:~0,1%"=="%input:~0,1%" (
    echo %stl%
    echo %stl% | find "-" > nul
    if not errorlevel 1 (
        echo %stl% | find "FA" > nul
        if not errorlevel 1 (
            set input=%input:~1% && call :GEN_FA_Loc) else (
            set input=%input:~1% && call :GEN_Loc
        )
    ) else (
        echo %stl% | find "FA" > nul
        if not errorlevel 1 (
            set input=%input:~1% && call :OWN_FA_Loc) else (
            echo %stl% | find "PKI" > nul
            if not errorlevel 1 (
                set input=%input:~1% && call :PKI_Loc) else (
                set input=%input:~1% && call :OWN_Loc
            )
        )
    )
)
    
goto :eof



:OWN_Loc
xcopy %tool_path%\%machineO%\INI\DE\Localize.ini %src_path%\Model\%machineO%\CUSTOM\INI\DE /c /f /i /y
xcopy %tool_path%\%machineO%\INI\EN\Localize.ini %src_path%\Model\%machineO%\CUSTOM\INI\EN /c /f /i /y
xcopy %tool_path%\%machineO%\INI\ES\Localize.ini %src_path%\Model\%machineO%\CUSTOM\INI\ES /c /f /i /y
xcopy %tool_path%\%machineO%\INI\FR\Localize.ini %src_path%\Model\%machineO%\CUSTOM\INI\FR /c /f /i /y
xcopy %tool_path%\%machineO%\INI\IT\Localize.ini %src_path%\Model\%machineO%\CUSTOM\INI\IT /c /f /i /y
xcopy %tool_path%\%machineO%\INI\JA\Localize.ini %src_path%\Model\%machineO%\CUSTOM\INI\JA /c /f /i /y
xcopy %tool_path%\%machineO%\INI\KO\Localize.ini %src_path%\Model\%machineO%\CUSTOM\INI\KO /c /f /i /y
xcopy %tool_path%\%machineO%\INI\ZH-CN\Localize.ini %src_path%\Model\%machineO%\CUSTOM\INI\ZH-CN /c /f /i /y
xcopy %tool_path%\%machineO%\INI\ZH-TW\Localize.ini %src_path%\Model\%machineO%\CUSTOM\INI\ZH-TW /c /f /i /y

xcopy %tool_path%\%machineO%\INI\DE\PrvLocalize.ini %src_path%\Driver\XPSPREVIEW\Customization\%machineO%\Localize\DE /c /f /i /y
xcopy %tool_path%\%machineO%\INI\EN\PrvLocalize.ini %src_path%\Driver\XPSPREVIEW\Customization\%machineO%\Localize\EN /c /f /i /y
xcopy %tool_path%\%machineO%\INI\ES\PrvLocalize.ini %src_path%\Driver\XPSPREVIEW\Customization\%machineO%\Localize\ES /c /f /i /y
xcopy %tool_path%\%machineO%\INI\FR\PrvLocalize.ini %src_path%\Driver\XPSPREVIEW\Customization\%machineO%\Localize\FR /c /f /i /y
xcopy %tool_path%\%machineO%\INI\IT\PrvLocalize.ini %src_path%\Driver\XPSPREVIEW\Customization\%machineO%\Localize\IT /c /f /i /y
xcopy %tool_path%\%machineO%\INI\JA\PrvLocalize.ini %src_path%\Driver\XPSPREVIEW\Customization\%machineO%\Localize\JA /c /f /i /y
xcopy %tool_path%\%machineO%\INI\KO\PrvLocalize.ini %src_path%\Driver\XPSPREVIEW\Customization\%machineO%\Localize\KO /c /f /i /y
xcopy %tool_path%\%machineO%\INI\ZH-CN\PrvLocalize.ini %src_path%\Driver\XPSPREVIEW\Customization\%machineO%\Localize\ZH-CN /c /f /i /y
xcopy %tool_path%\%machineO%\INI\ZH-TW\PrvLocalize.ini %src_path%\Driver\XPSPREVIEW\Customization\%machineO%\Localize\ZH-TW /c /f /i /y
goto :eof

:OWN_FA_Loc
xcopy %tool_path%\%machineOF%\INI\DE\Localize.ini %src_path%\Model\%machineOF%\CUSTOM\INI\DE /c /f /i /y
xcopy %tool_path%\%machineOF%\INI\EN\Localize.ini %src_path%\Model\%machineOF%\CUSTOM\INI\EN /c /f /i /y
xcopy %tool_path%\%machineOF%\INI\ES\Localize.ini %src_path%\Model\%machineOF%\CUSTOM\INI\ES /c /f /i /y
xcopy %tool_path%\%machineOF%\INI\FR\Localize.ini %src_path%\Model\%machineOF%\CUSTOM\INI\FR /c /f /i /y
xcopy %tool_path%\%machineOF%\INI\IT\Localize.ini %src_path%\Model\%machineOF%\CUSTOM\INI\IT /c /f /i /y
xcopy %tool_path%\%machineOF%\INI\JA\Localize.ini %src_path%\Model\%machineOF%\CUSTOM\INI\JA /c /f /i /y
xcopy %tool_path%\%machineOF%\INI\KO\Localize.ini %src_path%\Model\%machineOF%\CUSTOM\INI\KO /c /f /i /y
xcopy %tool_path%\%machineOF%\INI\ZH-CN\Localize.ini %src_path%\Model\%machineOF%\CUSTOM\INI\ZH-CN /c /f /i /y
xcopy %tool_path%\%machineOF%\INI\ZH-TW\Localize.ini %src_path%\Model\%machineOF%\CUSTOM\INI\ZH-TW /c /f /i /y

xcopy %tool_path%\%machineOF%\INI\DE\LocalizePB.ini %src_path%\Model\%machineOF%\CUSTOM\INI\DE /c /f /i /y
xcopy %tool_path%\%machineOF%\INI\EN\LocalizePB.ini %src_path%\Model\%machineOF%\CUSTOM\INI\EN /c /f /i /y
xcopy %tool_path%\%machineOF%\INI\ES\LocalizePB.ini %src_path%\Model\%machineOF%\CUSTOM\INI\ES /c /f /i /y
xcopy %tool_path%\%machineOF%\INI\FR\LocalizePB.ini %src_path%\Model\%machineOF%\CUSTOM\INI\FR /c /f /i /y
xcopy %tool_path%\%machineOF%\INI\IT\LocalizePB.ini %src_path%\Model\%machineOF%\CUSTOM\INI\IT /c /f /i /y
xcopy %tool_path%\%machineOF%\INI\JA\LocalizePB.ini %src_path%\Model\%machineOF%\CUSTOM\INI\JA /c /f /i /y
xcopy %tool_path%\%machineOF%\INI\KO\LocalizePB.ini %src_path%\Model\%machineOF%\CUSTOM\INI\KO /c /f /i /y
xcopy %tool_path%\%machineOF%\INI\ZH-CN\LocalizePB.ini %src_path%\Model\%machineOF%\CUSTOM\INI\ZH-CN /c /f /i /y
xcopy %tool_path%\%machineOF%\INI\ZH-TW\LocalizePB.ini %src_path%\Model\%machineOF%\CUSTOM\INI\ZH-TW /c /f /i /y
goto :eof

:GEN_Loc
xcopy %tool_path%\%machineG%\INI\DE\Localize.ini %src_path%\Model\%machineG%\CUSTOM\INI\DE /c /f /i /y
xcopy %tool_path%\%machineG%\INI\EN\Localize.ini %src_path%\Model\%machineG%\CUSTOM\INI\EN /c /f /i /y
xcopy %tool_path%\%machineG%\INI\ES\Localize.ini %src_path%\Model\%machineG%\CUSTOM\INI\ES /c /f /i /y
xcopy %tool_path%\%machineG%\INI\FR\Localize.ini %src_path%\Model\%machineG%\CUSTOM\INI\FR /c /f /i /y
xcopy %tool_path%\%machineG%\INI\IT\Localize.ini %src_path%\Model\%machineG%\CUSTOM\INI\IT /c /f /i /y
xcopy %tool_path%\%machineG%\INI\JA\Localize.ini %src_path%\Model\%machineG%\CUSTOM\INI\JA /c /f /i /y
xcopy %tool_path%\%machineG%\INI\KO\Localize.ini %src_path%\Model\%machineG%\CUSTOM\INI\KO /c /f /i /y
xcopy %tool_path%\%machineG%\INI\ZH-CN\Localize.ini %src_path%\Model\%machineG%\CUSTOM\INI\ZH-CN /c /f /i /y
xcopy %tool_path%\%machineG%\INI\ZH-TW\Localize.ini %src_path%\Model\%machineG%\CUSTOM\INI\ZH-TW /c /f /i /y

xcopy %tool_path%\%machineG%\INI\DE\PrvLocalize.ini %src_path%\Driver\XPSPREVIEW\Customization\%machineG%\Localize\DE /c /f /i /y
xcopy %tool_path%\%machineG%\INI\EN\PrvLocalize.ini %src_path%\Driver\XPSPREVIEW\Customization\%machineG%\Localize\EN /c /f /i /y
xcopy %tool_path%\%machineG%\INI\ES\PrvLocalize.ini %src_path%\Driver\XPSPREVIEW\Customization\%machineG%\Localize\ES /c /f /i /y
xcopy %tool_path%\%machineG%\INI\FR\PrvLocalize.ini %src_path%\Driver\XPSPREVIEW\Customization\%machineG%\Localize\FR /c /f /i /y
xcopy %tool_path%\%machineG%\INI\IT\PrvLocalize.ini %src_path%\Driver\XPSPREVIEW\Customization\%machineG%\Localize\IT /c /f /i /y
xcopy %tool_path%\%machineG%\INI\JA\PrvLocalize.ini %src_path%\Driver\XPSPREVIEW\Customization\%machineG%\Localize\JA /c /f /i /y
xcopy %tool_path%\%machineG%\INI\KO\PrvLocalize.ini %src_path%\Driver\XPSPREVIEW\Customization\%machineG%\Localize\KO /c /f /i /y
xcopy %tool_path%\%machineG%\INI\ZH-CN\PrvLocalize.ini %src_path%\Driver\XPSPREVIEW\Customization\%machineG%\Localize\ZH-CN /c /f /i /y
xcopy %tool_path%\%machineG%\INI\ZH-TW\PrvLocalize.ini %src_path%\Driver\XPSPREVIEW\Customization\%machineG%\Localize\ZH-TW /c /f /i /y
goto :eof

:GEN_FA_Loc
xcopy %tool_path%\%machineGF%\INI\DE\Localize.ini %src_path%\Model\%machineGF%\CUSTOM\INI\DE /c /f /i /y
xcopy %tool_path%\%machineGF%\INI\EN\Localize.ini %src_path%\Model\%machineGF%\CUSTOM\INI\EN /c /f /i /y
xcopy %tool_path%\%machineGF%\INI\ES\Localize.ini %src_path%\Model\%machineGF%\CUSTOM\INI\ES /c /f /i /y
xcopy %tool_path%\%machineGF%\INI\FR\Localize.ini %src_path%\Model\%machineGF%\CUSTOM\INI\FR /c /f /i /y
xcopy %tool_path%\%machineGF%\INI\IT\Localize.ini %src_path%\Model\%machineGF%\CUSTOM\INI\IT /c /f /i /y
xcopy %tool_path%\%machineGF%\INI\JA\Localize.ini %src_path%\Model\%machineGF%\CUSTOM\INI\JA /c /f /i /y
xcopy %tool_path%\%machineGF%\INI\KO\Localize.ini %src_path%\Model\%machineGF%\CUSTOM\INI\KO /c /f /i /y
xcopy %tool_path%\%machineGF%\INI\ZH-CN\Localize.ini %src_path%\Model\%machineGF%\CUSTOM\INI\ZH-CN /c /f /i /y
xcopy %tool_path%\%machineGF%\INI\ZH-TW\Localize.ini %src_path%\Model\%machineGF%\CUSTOM\INI\ZH-TW /c /f /i /y

xcopy %tool_path%\%machineGF%\INI\DE\LocalizePB.ini %src_path%\Model\%machineGF%\CUSTOM\INI\DE /c /f /i /y
xcopy %tool_path%\%machineGF%\INI\EN\LocalizePB.ini %src_path%\Model\%machineGF%\CUSTOM\INI\EN /c /f /i /y
xcopy %tool_path%\%machineGF%\INI\ES\LocalizePB.ini %src_path%\Model\%machineGF%\CUSTOM\INI\ES /c /f /i /y
xcopy %tool_path%\%machineGF%\INI\FR\LocalizePB.ini %src_path%\Model\%machineGF%\CUSTOM\INI\FR /c /f /i /y
xcopy %tool_path%\%machineGF%\INI\IT\LocalizePB.ini %src_path%\Model\%machineGF%\CUSTOM\INI\IT /c /f /i /y
xcopy %tool_path%\%machineGF%\INI\JA\LocalizePB.ini %src_path%\Model\%machineGF%\CUSTOM\INI\JA /c /f /i /y
xcopy %tool_path%\%machineGF%\INI\KO\LocalizePB.ini %src_path%\Model\%machineGF%\CUSTOM\INI\KO /c /f /i /y
xcopy %tool_path%\%machineGF%\INI\ZH-CN\LocalizePB.ini %src_path%\Model\%machineGF%\CUSTOM\INI\ZH-CN /c /f /i /y
xcopy %tool_path%\%machineGF%\INI\ZH-TW\LocalizePB.ini %src_path%\Model\%machineGF%\CUSTOM\INI\ZH-TW /c /f /i /y
goto :eof

:PKI_Loc
xcopy %tool_path%\%machineP%\INI\EN\Localize.ini %src_path%\Model\%machineP%\CUSTOM\INI\EN /c /f /i /y
goto :eof

pause