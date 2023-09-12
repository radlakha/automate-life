@echo off
REM Description: This script will create a incremental backup of the folder and subfolders in the current directory
REM Display current working directory and desired backup drive and ask for confirmation

REM Usage: fullBackup.bat <backup drive letter> <ROBOCOPY options>
REM Example: fullBackup.bat D /L
REM Example: fullBackup.bat D /L /TEE /LOG+:.\backup.log


REM get local date in format - 2019-08-29 15:21:41.652
for /F "usebackq tokens=1,2 delims==" %%i in (`wmic os get LocalDateTime /VALUE 2^>NUL`) do if '.%%i.'=='.LocalDateTime.' set ldt=%%j
set ldt=%ldt:~0,4%-%ldt:~4,2%-%ldt:~6,2% %ldt:~8,2%:%ldt:~10,2%:%ldt:~12,6%

REM get the foldaer date parameter in format - 20190829
set mydate=%ldt:~0,4%%ldt:~5,2%%ldt:~8,2%

@echo "Backup of %cd% to %1:\%mydate% - Incremental Backup"
@pause 'Press Ctrl+C to cancel or any other key to continue'

REM call ROBOCOPY assuming your thumbdrive is mapped as %1:
REM /A is not needed if /M is used - you are just being over cautious
REM pass /L on command line if you just need a dry run
ROBOCOPY "." "%1:\%mydate% - Incremental Backup" %2 /A /M /E /XA:SH /R:2 /W:2 /REG /xd $RECYCLE.BIN "System Volume Information"


