@echo off
setlocal enabledelayedexpansion 
title LocalizeCopyTool


:tool
cls
set tool_path=
echo *************************************************************
echo 1.Input created Localize folder path in tool.(copy from)
echo.
echo sample: E:\Zeus-S_ECT_Project
echo *************************************************************

set /p tool_path=Drag folder here: 
:: judge tool_path value is null
if "%tool_path%"=="" (echo Please Re-enter Path After Press Any Button. & pause>nul && goto tool)


:src
cls
set src_path=
echo *************************************************************
echo 2.Input target Localize folder path in source.(copy to)
echo.
echo sample: F:\WinDrv_Src\IT5_Color_v3.0\KMSrc_2.06.34\Driver
echo *************************************************************

set /p src_path=Drag folder here: 
:: judge src_path value is null
if "%src_path%"=="" (echo Please Re-enter Path After Press Any Button. & pause>nul && goto src)


:cfm
cls
echo *************************************************************
echo 3. Confirm your setting
echo.
echo Copy from: %tool_path%
echo Copy to:   %src_path%
echo *************************************************************

:: define value of folder copied from tool_path
for /d %%i in (%tool_path%\*) do (
    echo %%~ni | find "-" > nul
    if not errorlevel 1 (
        :: GEN FA
        echo %%~ni | find "FA" > nul
        if not errorlevel 1 (
            :: GEN PRT
            set machineGF_T=%%~ni) else (
            set machineG_T=%%~ni
        )
    ) else (
        echo %%~ni | find "FA" > nul
        if not errorlevel 1 (
            :: OWN FA
            set machineOF_T=%%~ni) else (
            :: NOT PKI
            echo %%~ni | find "PKI" > nul
            if not errorlevel 1 (
                :: OWN PRT PKI
                set machineP_T=%%~ni) else (
                :: Exclude SCCopy Folder
                echo %%~ni | find "SCCopy" > nul
                if errorlevel 1 (
                    :: OWN PRT 
                    set machineO_T=%%~ni
                )
            )
        )
    )   
)

:: define value of folder copied from src_path
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

:: judge every model is null
if "%machineGF_T%"=="" (echo WARN:GENFAX NOT FOUND IN TOOL )
if "%machineG_T%"=="" (echo WARN:GEN NOT FOUND IN TOOL )
if "%machineOF_T%"=="" (echo WARN:OWNFAX NOT FOUND IN TOOL )
if "%machineP_T%"=="" (echo WARN:PKI NOT FOUND IN TOOL )
if "%machineO_T%"=="" (echo WARN:OWN NOT FOUND IN TOOL )
if "%machineGF_S%"=="" (echo WARN:GENFAX NOT FOUND IN SOURCE )
if "%machineG_S%"=="" (echo WARN:GEN NOT FOUND IN SOURCE )
if "%machineOF_S%"=="" (echo WARN:OWNFAX NOT FOUND IN SOURCE )
if "%machineP_S%"=="" (echo WARN:PKI NOT FOUND IN SOURCE )
if "%machineO_S%"=="" (echo WARN:OWN NOT FOUND IN SOURCE )

echo Press [Y/y] to execute.
echo Press [N/n] to reset path.
choice
:: if Y/y errorlevel==1, if N/n errorlevel==2
if errorlevel 1 (pause>nul)
if errorlevel 2 (goto tool)

:choice
:: assign a number to model & connect number and model
set /a n=0
set PDL_NB1=
set PDL_NB2=
set PDL_NB3=
set PDL_NB4=
set PDL_NB5=
if "%machineGF_T%"=="%machineGF_S%" (set /a n+=1 && set PDL_NB1=!n!.%machineGF_S%)
if "%machineG_T%"=="%machineG_S%" (set /a n+=1 && set PDL_NB2=!n!.%machineG_S%)
if "%machineOF_T%"=="%machineOF_S%" (set /a n+=1 && set PDL_NB3=!n!.%machineOF_S%)
if "%machineO_T%"=="%machineO_S%" (set /a n+=1 && set PDL_NB4=!n!.%machineO_S%)
if "%machineP_T%"=="%machineP_S%" (set /a n+=1 && set PDL_NB5=!n!.%machineP_S%)

:: number and model write in a string1
set PDL_NB=%PDL_NB1% %PDL_NB2% %PDL_NB3% %PDL_NB4% %PDL_NB5%
:: delete null value of string
if "%PDL_NB:~0,1%"==""(set PDL_NB=%PDL_NB:~1%)
echo %PDL_NB%
:: input number of model as string2,several number selectable
set /p input=Above available types, choice number: 
if "%input%"=="" (echo Please enter  order numbers of types. & pause>nul && goto choice)

:: loop,find string2(input number) in string1(number and model)  
for %%i in (%PDL_NB%) do call :pickup %%i 
pause


:pickup 
:: %1:get the first value of string1,the second value become the first value in next loop
set stl=%1

:: avoid input strings is null,exception handling
if "%stl%"=="" goto :eof
if "%input%"=="" goto :eof
:: modle of number in keeping with the first inputed number in this loop
if "%stl:~0,1%"=="%input:~0,1%" (
    echo %stl% | find "-" > nul
    if not errorlevel 1 (
        echo %stl% | find "FA" > nul		
        if not errorlevel 1 (
		    :: delete the first number in inputed number,skip to corresponding label to copy
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
xcopy %tool_path%\%machineO_T%\INI\DE\Localize.ini %src_path%\Model\%machineO_S%\CUSTOM\INI\DE /c /f /i /y
xcopy %tool_path%\%machineO_T%\INI\EN\Localize.ini %src_path%\Model\%machineO_S%\CUSTOM\INI\EN /c /f /i /y
xcopy %tool_path%\%machineO_T%\INI\ES\Localize.ini %src_path%\Model\%machineO_S%\CUSTOM\INI\ES /c /f /i /y
xcopy %tool_path%\%machineO_T%\INI\FR\Localize.ini %src_path%\Model\%machineO_S%\CUSTOM\INI\FR /c /f /i /y
xcopy %tool_path%\%machineO_T%\INI\IT\Localize.ini %src_path%\Model\%machineO_S%\CUSTOM\INI\IT /c /f /i /y
xcopy %tool_path%\%machineO_T%\INI\JA\Localize.ini %src_path%\Model\%machineO_S%\CUSTOM\INI\JA /c /f /i /y
xcopy %tool_path%\%machineO_T%\INI\KO\Localize.ini %src_path%\Model\%machineO_S%\CUSTOM\INI\KO /c /f /i /y
xcopy %tool_path%\%machineO_T%\INI\ZH-CN\Localize.ini %src_path%\Model\%machineO_S%\CUSTOM\INI\ZH-CN /c /f /i /y
xcopy %tool_path%\%machineO_T%\INI\ZH-TW\Localize.ini %src_path%\Model\%machineO_S%\CUSTOM\INI\ZH-TW /c /f /i /y

xcopy %tool_path%\%machineO_T%\INI\DE\PrvLocalize.ini %src_path%\Driver\XPSPREVIEW\Preview\Customization\%machineO_S%\Localize\DE /c /f /i /y
xcopy %tool_path%\%machineO_T%\INI\EN\PrvLocalize.ini %src_path%\Driver\XPSPREVIEW\Preview\Customization\%machineO_S%\Localize\EN /c /f /i /y
xcopy %tool_path%\%machineO_T%\INI\ES\PrvLocalize.ini %src_path%\Driver\XPSPREVIEW\Preview\Customization\%machineO_S%\Localize\ES /c /f /i /y
xcopy %tool_path%\%machineO_T%\INI\FR\PrvLocalize.ini %src_path%\Driver\XPSPREVIEW\Preview\Customization\%machineO_S%\Localize\FR /c /f /i /y
xcopy %tool_path%\%machineO_T%\INI\IT\PrvLocalize.ini %src_path%\Driver\XPSPREVIEW\Preview\Customization\%machineO_S%\Localize\IT /c /f /i /y
xcopy %tool_path%\%machineO_T%\INI\JA\PrvLocalize.ini %src_path%\Driver\XPSPREVIEW\Preview\Customization\%machineO_S%\Localize\JA /c /f /i /y
xcopy %tool_path%\%machineO_T%\INI\KO\PrvLocalize.ini %src_path%\Driver\XPSPREVIEW\Preview\Customization\%machineO_S%\Localize\KO /c /f /i /y
xcopy %tool_path%\%machineO_T%\INI\ZH-CN\PrvLocalize.ini %src_path%\Driver\XPSPREVIEW\Preview\Customization\%machineO_S%\Localize\ZH-CN /c /f /i /y
xcopy %tool_path%\%machineO_T%\INI\ZH-TW\PrvLocalize.ini %src_path%\Driver\XPSPREVIEW\Preview\Customization\%machineO_S%\Localize\ZH-TW /c /f /i /y
goto :eof


:OWN_FA_Loc
xcopy %tool_path%\%machineOF_T%\INI\DE\Localize.ini %src_path%\Model\%machineOF_S%\CUSTOM\INI\DE /c /f /i /y
xcopy %tool_path%\%machineOF_T%\INI\EN\Localize.ini %src_path%\Model\%machineOF_S%\CUSTOM\INI\EN /c /f /i /y
xcopy %tool_path%\%machineOF_T%\INI\ES\Localize.ini %src_path%\Model\%machineOF_S%\CUSTOM\INI\ES /c /f /i /y
xcopy %tool_path%\%machineOF_T%\INI\FR\Localize.ini %src_path%\Model\%machineOF_S%\CUSTOM\INI\FR /c /f /i /y
xcopy %tool_path%\%machineOF_T%\INI\IT\Localize.ini %src_path%\Model\%machineOF_S%\CUSTOM\INI\IT /c /f /i /y
xcopy %tool_path%\%machineOF_T%\INI\JA\Localize.ini %src_path%\Model\%machineOF_S%\CUSTOM\INI\JA /c /f /i /y
xcopy %tool_path%\%machineOF_T%\INI\KO\Localize.ini %src_path%\Model\%machineOF_S%\CUSTOM\INI\KO /c /f /i /y
xcopy %tool_path%\%machineOF_T%\INI\ZH-CN\Localize.ini %src_path%\Model\%machineOF_S%\CUSTOM\INI\ZH-CN /c /f /i /y
xcopy %tool_path%\%machineOF_T%\INI\ZH-TW\Localize.ini %src_path%\Model\%machineOF_S%\CUSTOM\INI\ZH-TW /c /f /i /y

xcopy %tool_path%\%machineOF_T%\INI\DE\LocalizePB.ini %src_path%\Model\%machineOF_S%\CUSTOM\INI\DE /c /f /i /y
xcopy %tool_path%\%machineOF_T%\INI\EN\LocalizePB.ini %src_path%\Model\%machineOF_S%\CUSTOM\INI\EN /c /f /i /y
xcopy %tool_path%\%machineOF_T%\INI\ES\LocalizePB.ini %src_path%\Model\%machineOF_S%\CUSTOM\INI\ES /c /f /i /y
xcopy %tool_path%\%machineOF_T%\INI\FR\LocalizePB.ini %src_path%\Model\%machineOF_S%\CUSTOM\INI\FR /c /f /i /y
xcopy %tool_path%\%machineOF_T%\INI\IT\LocalizePB.ini %src_path%\Model\%machineOF_S%\CUSTOM\INI\IT /c /f /i /y
xcopy %tool_path%\%machineOF_T%\INI\JA\LocalizePB.ini %src_path%\Model\%machineOF_S%\CUSTOM\INI\JA /c /f /i /y
xcopy %tool_path%\%machineOF_T%\INI\KO\LocalizePB.ini %src_path%\Model\%machineOF_S%\CUSTOM\INI\KO /c /f /i /y
xcopy %tool_path%\%machineOF_T%\INI\ZH-CN\LocalizePB.ini %src_path%\Model\%machineOF_S%\CUSTOM\INI\ZH-CN /c /f /i /y
xcopy %tool_path%\%machineOF_T%\INI\ZH-TW\LocalizePB.ini %src_path%\Model\%machineOF_S%\CUSTOM\INI\ZH-TW /c /f /i /y
goto :eof


:GEN_Loc
xcopy %tool_path%\%machineG_T%\INI\DE\Localize.ini %src_path%\Model\%machineG_S%\CUSTOM\INI\DE /c /f /i /y
xcopy %tool_path%\%machineG_T%\INI\EN\Localize.ini %src_path%\Model\%machineG_S%\CUSTOM\INI\EN /c /f /i /y
xcopy %tool_path%\%machineG_T%\INI\ES\Localize.ini %src_path%\Model\%machineG_S%\CUSTOM\INI\ES /c /f /i /y
xcopy %tool_path%\%machineG_T%\INI\FR\Localize.ini %src_path%\Model\%machineG_S%\CUSTOM\INI\FR /c /f /i /y
xcopy %tool_path%\%machineG_T%\INI\IT\Localize.ini %src_path%\Model\%machineG_S%\CUSTOM\INI\IT /c /f /i /y
xcopy %tool_path%\%machineG_T%\INI\JA\Localize.ini %src_path%\Model\%machineG_S%\CUSTOM\INI\JA /c /f /i /y
xcopy %tool_path%\%machineG_T%\INI\KO\Localize.ini %src_path%\Model\%machineG_S%\CUSTOM\INI\KO /c /f /i /y
xcopy %tool_path%\%machineG_T%\INI\ZH-CN\Localize.ini %src_path%\Model\%machineG_S%\CUSTOM\INI\ZH-CN /c /f /i /y
xcopy %tool_path%\%machineG_T%\INI\ZH-TW\Localize.ini %src_path%\Model\%machineG_S%\CUSTOM\INI\ZH-TW /c /f /i /y

xcopy %tool_path%\%machineG_T%\INI\DE\PrvLocalize.ini %src_path%\Driver\XPSPREVIEW\Preview\Customization\%machineG_S%\Localize\DE /c /f /i /y
xcopy %tool_path%\%machineG_T%\INI\EN\PrvLocalize.ini %src_path%\Driver\XPSPREVIEW\Preview\Customization\%machineG_S%\Localize\EN /c /f /i /y
xcopy %tool_path%\%machineG_T%\INI\ES\PrvLocalize.ini %src_path%\Driver\XPSPREVIEW\Preview\Customization\%machineG_S%\Localize\ES /c /f /i /y
xcopy %tool_path%\%machineG_T%\INI\FR\PrvLocalize.ini %src_path%\Driver\XPSPREVIEW\Preview\Customization\%machineG_S%\Localize\FR /c /f /i /y
xcopy %tool_path%\%machineG_T%\INI\IT\PrvLocalize.ini %src_path%\Driver\XPSPREVIEW\Preview\Customization\%machineG_S%\Localize\IT /c /f /i /y
xcopy %tool_path%\%machineG_T%\INI\JA\PrvLocalize.ini %src_path%\Driver\XPSPREVIEW\Preview\Customization\%machineG_S%\Localize\JA /c /f /i /y
xcopy %tool_path%\%machineG_T%\INI\KO\PrvLocalize.ini %src_path%\Driver\XPSPREVIEW\Preview\Customization\%machineG_S%\Localize\KO /c /f /i /y
xcopy %tool_path%\%machineG_T%\INI\ZH-CN\PrvLocalize.ini %src_path%\Driver\XPSPREVIEW\Preview\Customization\%machineG_S%\Localize\ZH-CN /c /f /i /y
xcopy %tool_path%\%machineG_T%\INI\ZH-TW\PrvLocalize.ini %src_path%\Driver\XPSPREVIEW\Preview\Customization\%machineG_S%\Localize\ZH-TW /c /f /i /y
goto :eof


:GEN_FA_Loc
xcopy %tool_path%\%machineGF_T%\INI\DE\Localize.ini %src_path%\Model\%machineGF_S%\CUSTOM\INI\DE /c /f /i /y
xcopy %tool_path%\%machineGF_T%\INI\EN\Localize.ini %src_path%\Model\%machineGF_S%\CUSTOM\INI\EN /c /f /i /y
xcopy %tool_path%\%machineGF_T%\INI\ES\Localize.ini %src_path%\Model\%machineGF_S%\CUSTOM\INI\ES /c /f /i /y
xcopy %tool_path%\%machineGF_T%\INI\FR\Localize.ini %src_path%\Model\%machineGF_S%\CUSTOM\INI\FR /c /f /i /y
xcopy %tool_path%\%machineGF_T%\INI\IT\Localize.ini %src_path%\Model\%machineGF_S%\CUSTOM\INI\IT /c /f /i /y
xcopy %tool_path%\%machineGF_T%\INI\JA\Localize.ini %src_path%\Model\%machineGF_S%\CUSTOM\INI\JA /c /f /i /y
xcopy %tool_path%\%machineGF_T%\INI\KO\Localize.ini %src_path%\Model\%machineGF_S%\CUSTOM\INI\KO /c /f /i /y
xcopy %tool_path%\%machineGF_T%\INI\ZH-CN\Localize.ini %src_path%\Model\%machineGF_S%\CUSTOM\INI\ZH-CN /c /f /i /y
xcopy %tool_path%\%machineGF_T%\INI\ZH-TW\Localize.ini %src_path%\Model\%machineGF_S%\CUSTOM\INI\ZH-TW /c /f /i /y

xcopy %tool_path%\%machineGF_T%\INI\DE\LocalizePB.ini %src_path%\Model\%machineGF_S%\CUSTOM\INI\DE /c /f /i /y
xcopy %tool_path%\%machineGF_T%\INI\EN\LocalizePB.ini %src_path%\Model\%machineGF_S%\CUSTOM\INI\EN /c /f /i /y
xcopy %tool_path%\%machineGF_T%\INI\ES\LocalizePB.ini %src_path%\Model\%machineGF_S%\CUSTOM\INI\ES /c /f /i /y
xcopy %tool_path%\%machineGF_T%\INI\FR\LocalizePB.ini %src_path%\Model\%machineGF_S%\CUSTOM\INI\FR /c /f /i /y
xcopy %tool_path%\%machineGF_T%\INI\IT\LocalizePB.ini %src_path%\Model\%machineGF_S%\CUSTOM\INI\IT /c /f /i /y
xcopy %tool_path%\%machineGF_T%\INI\JA\LocalizePB.ini %src_path%\Model\%machineGF_S%\CUSTOM\INI\JA /c /f /i /y
xcopy %tool_path%\%machineGF_T%\INI\KO\LocalizePB.ini %src_path%\Model\%machineGF_S%\CUSTOM\INI\KO /c /f /i /y
xcopy %tool_path%\%machineGF_T%\INI\ZH-CN\LocalizePB.ini %src_path%\Model\%machineGF_S%\CUSTOM\INI\ZH-CN /c /f /i /y
xcopy %tool_path%\%machineGF_T%\INI\ZH-TW\LocalizePB.ini %src_path%\Model\%machineGF_S%\CUSTOM\INI\ZH-TW /c /f /i /y
goto :eof


:PKI_Loc
xcopy %tool_path%\%machineP_T%\INI\EN\Localize.ini %src_path%\Model\%machineP_S%\CUSTOM\INI\EN /c /f /i /y
goto :eof

pause