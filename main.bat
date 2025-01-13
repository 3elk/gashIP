cls
@echo off

:START
cls
title gashIP - by elk
chcp 65001 >nul

:: Print the working directory
echo Current directory: %cd%
echo.

:: Enable delayed variable expansion
setlocal EnableDelayedExpansion

:INPUT
:: Prompt for the file containing IP addresses with more detailed instruction
cls
call :banner
echo.           
echo       ________________________________________Hello, welcome to [32mgashIP[0m._______________________________________
echo      │ Enter the name of the TXT file with the desired IPs with its extension in the directory.               │
echo      │   If said TXT is not in this directory, make sure write the full complete path of the TXT file.        │
echo      │__________________________If assistance is needed, type in the command, "HELP"._________________________│
echo                                 │______________________by elk :3____________________│
set /p ipFile=

:: Handle HELP command
if /i "%ipFile%"=="HELP" (
    cls
    echo. 
	echo     HELP - How to use [32mgashIP[0m:
    echo  _______________________________________________________________________________________
    echo │1 -  Type the name of the TXT file with the IPs.                                       │
    echo │2 - [32mgashIP[0m will gather the geolocation information for each IP entered.                │
    echo │3 - The information of the IPs when finished will be located in the following folders: │
    echo │  - Raw JSON responses: output\json_results                                            │   
    echo │  - Extracted geolocation information: output\geolocation_results                      │
    echo │______________________________________COMMANDS_________________________________________│
    echo │1 - Write the command "LOG" to see information on your previously scanned IPs.         │
    echo │2 - Type the command "HELP" to have a guide on how to use [32mgashIP[0m.                      │   
	echo │3 - Type the command "MEDIA" to see my social media profiles.                          │
    echo │4 - Type the command "EXIT" to leave [32mgashIP[0m.                                           │
    echo │_______________________________________________________________________________________│
    pause
    goto INPUT
)

:: Handle LOG command
if /i "%ipFile%"=="LOG" (
    cls
    echo Scanned IP Logs:
    echo ______________________________
    if not exist "output\geolocation_results" (
        echo No logs found. Please scan some IPs first.
    ) else (
        for /r "output\geolocation_results" %%f in (*_geo.txt) do (
            echo Contents of %%~nxf:
            type "%%f"
            echo ______________________________
        )
    )
    pause
    goto INPUT
)

:: Handle EXIT command
if /i "%ipFile%"=="exit" (
    echo Exiting the gashIP. See you later!
    exit /b
)

:: Handle MEDIA command
if /i "%ipFile%"=="MEDIA" (
	cls
	echo.
	echo.
	echo  Social-Media Profiles:
	echo  ________________________________
	echo │ Biolink: Guns.lol/_            │
	echo │ Discord: @2elk                 │
	echo │ Roblox: @Onal                  │
	echo │ rest of my stuff is in my guns │
	echo │ join /xzc and /diddy btw       │
	echo │________________________________│
	pause
	goto INPUT
)
	
:: Check if the file exists
if not exist "%ipFile%" (
    echo The file "%ipFile%" does not exist. Please provide a valid file with its extension or specify its full path.
    echo.
    pause
    goto INPUT
)

:: Create output folder if it doesn't exist
if not exist "output\json_results" mkdir "output\json_results"
if not exist "output\geolocation_results" mkdir "output\geolocation_results"

:: Process each IP in the file
for /f "tokens=*" %%i in (%ipFile%) do (
    set ip=%%i
    echo Processing IP: !ip!
    
    :: Fetch raw JSON response from ipinfo.io and save it directly to a file
    curl -s "https://ipinfo.io/!ip!/json" -o "output\json_results\!ip!.json"

    :: Check if the JSON file was created successfully
    if not exist "output\json_results\!ip!.json" (
        echo Failed to fetch data for IP: !ip!
        echo --------------------------
        continue
    )

    :: Start writing the geolocation information
    echo Geolocation Information for IP !ip! > "output\geolocation_results\!ip!_geo.txt"
    echo -------------------------- >> "output\geolocation_results\!ip!_geo.txt"

    :: Extract city if it exists
    for /f "tokens=1,* delims=:" %%a in ('findstr /i "city" "output\json_results\!ip!.json"') do (
        set city=%%b
        echo City: !city! >> "output\geolocation_results\!ip!_geo.txt"
    )

    :: Extract other fields (region, country, etc.) similarly
    for %%f in (region country loc org postal timezone) do (
        for /f "tokens=1,* delims=:" %%a in ('findstr /i "%%f" "output\json_results\!ip!.json"') do (
            set fieldValue=%%b
            if "!fieldValue!"=="" (
                echo %%f: Field not found >> "output\geolocation_results\!ip!_geo.txt"
            ) else (
                echo %%f: !fieldValue! >> "output\geolocation_results\!ip!_geo.txt"
            )
        )
    )

    echo -------------------------- >> "output\geolocation_results\!ip!_geo.txt"
)

echo Processing complete. Thank you for using gashIP. The information is saved in the following folders:
echo - Raw JSON responses: output\json_results
echo - Extracted geolocation information: output\geolocation_results
pause
goto START

pause
:banner
echo.
echo.
echo [32m                      __    ________ [0m
echo [32m    ____ _____ ______/ /_  /  _/ __ \[0m
echo [32m   / __ `/ __ `/ ___/ __ \ / // /_/ /[0m
echo [32m  / /_/ / /_/ (__  ) / / // // ____/ [0m
echo [32m  \__, /\__,_/____/_/ /_/___/_/   (_) [0m
echo [32m /____/                              [0m
echo.
echo.
