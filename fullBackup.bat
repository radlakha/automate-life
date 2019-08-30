@echo off

REM get local date in format - 2019-08-29 15:21:41.652
for /F "usebackq tokens=1,2 delims==" %%i in (`wmic os get LocalDateTime /VALUE 2^>NUL`) do if '.%%i.'=='.LocalDateTime.' set ldt=%%j
set ldt=%ldt:~0,4%-%ldt:~4,2%-%ldt:~6,2% %ldt:~8,2%:%ldt:~10,2%:%ldt:~12,6%

REM get the foldaer date parameter in format - 20190829
set mydate=%ldt:~0,4%%ldt:~5,2%%ldt:~8,2%

REM call ROBOCOPY assuming your thumbdrive is mapped as D:
REM pass /L on command line if you just need a dry run
ROBOCOPY "C:\Users\radlakha\Documents" "D:\%mydate% - Full Backup" %1 /E /XA:SH /R:2 /W:2 /REG /xd $RECYCLE.BIN "System Volume Information"

REM since we did not use /A or /M (to get all files) we have to explicitly turn the archive bit off
attrib -A *.* /S

