@echo off
title ���ھ߱�
cls

:random
set /a onum1=%RANDOM%%%10
set /a onum2=%RANDOM%%%10
set /a onum3=%RANDOM%%%10
if "%onum1%" == "%onum2%" goto :random
if "%onum1%" == "%onum3%" goto :random
if "%onum2%" == "%onum3%" goto :random

echo.
echo                             ����������������������
echo                             ��     ���ھ߱�     ��
echo                             ����������������������
echo.
set count=0

:input
set inum=0
set strike=0
set ball=0
set /p inum=�ߺ����� ������ ���ڸ� �Է����ֽʽÿ�. : 
set /a inum1=%inum%/100
set /a inum2=%inum%%%100/10
set /a inum3=%inum%%%100%%10
if "%inum:~0,-2%" == "%inum:~1,-1%" goto :input
if "%inum:~0,-2%" == "%inum:~2%" goto :input
if "%inum:~1,-1%" == "%inum:~2%" goto :input
set /a count+=1

if "%inum:~0,-2%" == "%onum1%" set /a strike+=1
if "%inum:~1,-1%" == "%onum2%" set /a strike+=1
if "%inum:~2%" == "%onum3%" set /a strike+=1

if "%inum:~0,-2%" == "%onum2%" set /a ball+=1
if "%inum:~0,-2%" == "%onum3%" set /a ball+=1
if "%inum:~1,-1%" == "%onum1%" set /a ball+=1
if "%inum:~1,-1%" == "%onum3%" set /a ball+=1
if "%inum:~2%" == "%onum1%" set /a ball+=1
if "%inum:~2%" == "%onum2%" set /a ball+=1

if "%strike%%ball%" == "00" (
	echo      OUT
) else (
	echo      %strike%S%ball%B
)

if "%inum%" == "%onum1%%onum2%%onum3%" (
	echo.
	echo %count%������ �����ϼ̽��ϴ�!
	pause
	exit
)
goto :input