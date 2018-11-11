@echo off
set name=로컬 영역 연결
set address=
set mask=255.255.255.0
set gateway=
set dns1=
set dns2=

title %~n0
cls
if "%name%" == "" set go=a & goto :name
:a
if "%address%" == "" set go=b & goto :address
:b
if "%mask%" == "" set go=c & goto :mask
:c
if "%gateway%" == "" set go=d & goto :gateway
:d
if "%dns1%" == "" set go=e & goto :dns1
:e
if "%dns2%" == "" set go=f & goto :dns2
:f

:menu
set menu=
cls
echo.
echo                                어댑터 목록
netsh interface show interface
echo -------------------------------------------------------------------------
echo.
echo 1. 적용할 인터페이스:	%name%
echo 2. IP 주소:		%address%
echo 3. 서브넷 마스크:	%mask%
echo 4. 기본 게이트웨이:	%gateway%
echo 5. 기본 설정 DNS 서버:	%dns1%
echo 6. 보조 DNS 서버:	%dns2%
echo.
echo c. 적용
echo q. 종료
echo.
set /p menu=원하는 메뉴나 변경할 명령을 입력해주세요 : 
if /i "%menu%" == "1" set go=menu & goto :name
if /i "%menu%" == "2" set go=menu & goto :address
if /i "%menu%" == "3" set go=menu & goto :mask
if /i "%menu%" == "4" set go=menu & goto :gateway
if /i "%menu%" == "5" set go=menu & goto :dns1
if /i "%menu%" == "6" set go=menu & goto :dns2
if /i "%menu%" == "c" goto ok
if /i "%menu%" == "q" exit
goto :menu

:name
echo.
set /p name=어댑터의 이름을 입력해주세요 : 
if "%name%" == "" goto :name
goto :%go%

:address
echo.
set /p address=IP 주소를 입력해주세요 : 
if "%address%" == "" goto :address
for /f "delims=. tokens=1-3" %%i in ("%address%") do set gateway=%%i.%%j.%%k.1
goto :%go%

:mask
echo.
set /p mask=서브넷 마스크를 입력해주세요 : 
if "%mask%" == "" goto :mask
goto :%go%

:gateway
echo.
set /p gateway=기본 게이트웨이를 입력해주세요 : 
if "%gateway%" == "" goto :gateway
goto :%go%

:dns1
echo.
set /p dns1=기본 설정 DNS 서버를 입력해주세요 : 
if "%dns1%" == "" goto :dns1
goto :%go%

:dns2
echo.
set /p dns2=보조 DNS 서버를 입력해주세요 : 
if "%dns2%" == "" goto :dns2
goto :%go%

:ok
echo.
netsh interface ipv4 set address "%name%" static %address% %mask% %gateway%
netsh interface ipv4 set dnsservers "%name%" static %dns1% primary no
netsh interface ipv4 add dnsservers "%name%" %dns2% 2 no
pause
exit