@echo off
set name=���� ���� ����
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
echo                                ����� ���
netsh interface show interface
echo -------------------------------------------------------------------------
echo.
echo 1. ������ �������̽�:	%name%
echo 2. IP �ּ�:		%address%
echo 3. ����� ����ũ:	%mask%
echo 4. �⺻ ����Ʈ����:	%gateway%
echo 5. �⺻ ���� DNS ����:	%dns1%
echo 6. ���� DNS ����:	%dns2%
echo.
echo c. ����
echo q. ����
echo.
set /p menu=���ϴ� �޴��� ������ ����� �Է����ּ��� : 
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
set /p name=������� �̸��� �Է����ּ��� : 
if "%name%" == "" goto :name
goto :%go%

:address
echo.
set /p address=IP �ּҸ� �Է����ּ��� : 
if "%address%" == "" goto :address
for /f "delims=. tokens=1-3" %%i in ("%address%") do set gateway=%%i.%%j.%%k.1
goto :%go%

:mask
echo.
set /p mask=����� ����ũ�� �Է����ּ��� : 
if "%mask%" == "" goto :mask
goto :%go%

:gateway
echo.
set /p gateway=�⺻ ����Ʈ���̸� �Է����ּ��� : 
if "%gateway%" == "" goto :gateway
goto :%go%

:dns1
echo.
set /p dns1=�⺻ ���� DNS ������ �Է����ּ��� : 
if "%dns1%" == "" goto :dns1
goto :%go%

:dns2
echo.
set /p dns2=���� DNS ������ �Է����ּ��� : 
if "%dns2%" == "" goto :dns2
goto :%go%

:ok
echo.
netsh interface ipv4 set address "%name%" static %address% %mask% %gateway%
netsh interface ipv4 set dnsservers "%name%" static %dns1% primary no
netsh interface ipv4 add dnsservers "%name%" %dns2% 2 no
pause
exit