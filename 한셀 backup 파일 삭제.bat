@echo off
title %~n0
cls
for %%i in (A:\ B:\ C:\ D:\ E:\ F:\ G:\ H:\ I:\ J:\ K:\ L:\ M:\ N:\ O:\ P:\ Q:\ R:\ S:\ T:\ U:\ V:\ W:\ X:\ Y:\ Z:\) do if exist %%i call :DELETE %%i
echo 삭제 완료
pause
exit

:DELETE
echo %1 검사 중...
cd /d %1
del /f /s /q *.*.backup
echo.