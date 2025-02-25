@echo off
cls
:START
cls
title gashIP - by elk
chcp 65001 >nul
echo Current directory: %cd%
echo.
setlocal EnableDelayedExpansion
:INPUT
cls
echo.
echo.
echo [32m                      __    ________ [0m
echo [32m    ____ _____ ______/ /_  /  _/ __ \[0m
echo [32m   / __ `/ __ `/ ___/ __ \ / // /_/ /[0m
echo [32m  / /_/ / /_/ (__  ) / / // // ____/ [0m
echo [32m  \__, /\__,_/____/_/ /_/___/_/   (_)[0m
echo [32m /____/                              [0m
echo [32m                   b y  e l k        [0m
echo.
echo.
echo.         
echo                                                ┌──────────────────────────┐ 
echo      ┌─────────────────────────────────────────┘ Hello, welcome to [32mgashIP[0m.└───────────────────────────────────┐
echo      │      Enter the name of the TXT file with the desired IPs with its extension in the directory.          │
echo      │       If said TXT is not in this directory, make sure to drag the .txt file in to [32mgashIP[0m.              │
echo      └───────────────────────────┐If assistance is needed, type in the command, "HELP"┌───────────────────────┘
echo                                  └────────────────────────────────────────────────────┘
echo.
echo.
set /p ipFile= "Enter the name of the text file >> "
if /i "%ipFile%"=="HELP" ( cls
    title gashIP HELP - By elk
    echo. 
    echo ┌───────────────────────────────────────────────────────────────────────────────────────┐
	echo │                     HELP - How to use [32mgashIP[0m:             		                │
	echo │                                                                                       │  
    echo │1 Make a text file containing the IP you would like to geolocate                       │
	echo │2 Type in the file name inside of gashIP, Specify what type of file it is!              │
	echo │                    WAIT FOR IT TO FINISH                                              │
	echo │3 Check the newly created folder named "output" to see the results                     │
	echo │For the raw JSON Responses, goto the output folder json_results                        │
	echo │And for the geolocation info, go to the output folder geolocation_results              │
	echo │4 Just one more thing, DO NOT USE THIS TOOL WITH MALICIOUS INTENT!                      │
    echo │───────────────────────────────────────────────────────────────────────────────────────│
    echo │                                     COMMANDS:                                         │      
    echo │                                                                                       │  	
    echo │1 - Write the command "LOG" to see information on your previously scanned IPs.         │
    echo │2 - Type the command "HELP" to have a guide on how to use [32mgashIP[0m.                      │   
	echo │3 - Type the command "MEDIA" to see my social media profiles.                          │
    echo │4 - Type the command "EXIT" to leave [32mgashIP[0m.                                           │
    echo └───────────────────────────────────────────────────────────────────────────────────────┘
    pause
    goto INPUT)
if /i "%ipFile%"=="LOG" ( cls
    title gashIP LOGs - By elk
    echo Scanned IP Logs:
    echo ______________________________
    if not exist "output\geolocation_results" ( echo No logs found. Please scan some IPs first.) else (for /r "output\geolocation_results" %%f in (*_geo.txt) do ( echo Contents of %%~nxf:
            type "%%f"
            echo ______________________________
        )
    )
    pause
    goto INPUT)
if /i "%ipFile%"=="exit" ( title Closing gashIP.
    echo Closing gashIP, Goodbye %username%.
    timeout 1 /nobreak >nul
    exit )
if /i "%ipFile%"=="MEDIA" ( cls
    title gashIP MEDIA - By elk
	echo.
	echo.
	echo		 ┌───────────────────────────────────────┐
	echo		 │         Social-Media Profiles:        │
	echo		 │                                       │
	echo		 │ Biolink: Guns.lol/_                   │
	echo		 │ Discord: @2elk                        │
	echo		 │ GitHub: @3elk                         │
	echo		 │ Roblox: @Onal                         │
	echo		 │ rest of my stuff is in my guns.lol    │
	echo		 │ join /xzc and /diddy                  │
	echo		 └───────────────────────────────────────┘
	pause
	goto INPUT)
if not exist "%ipFile%" (   echo The file "%ipFile%" does not exist. Please provide a valid file. WITH THE EXTENSION
    echo.
    pause
    goto INPUT)
if not exist "output\json_results" mkdir "output\json_results"
if not exist "output\geolocation_results" mkdir "output\geolocation_results"
for /f "tokens=*" %%i in (%ipFile%) do (
    set ip=%%i
    echo Processing IP: !ip!
    curl -s "https://ipinfo.io/!ip!/json" -o "output\json_results\!ip!.json"
    if not exist "output\json_results\!ip!.json" (
        echo Failed to fetch data for the IP: !ip!
        echo --------------------------
    )
    echo Geolocation Information for IP !ip! >> "output\geolocation_results\!ip!_geo.txt"
    for /f "tokens=1,* delims=:" %%a in ('findstr /i "city" "output\json_results\!ip!.json"') do (
        set city=%%b
        echo City: !city! >> "output\geolocation_results\!ip!_geo.txt"
    )
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
type "output\json_results\!ip!.json"
echo.
echo.
echo Processing complete. Thank you for using gashIP. The information is saved in the following folders:
echo    - Raw JSON responses: output\json_results
echo    - Extracted geolocation information: output\geolocation_results
pause
goto START