@ECHO OFF

IF NOT "%VisualStudioVersion%" == "14.0" (
    ECHO You must be in a VS2015 command prompt
    ECHO Exiting
    Exit /B 1
)

set OPENSSL_VERSION=1.0.0t

ECHO 1/6 ....
perl Configure VC-WIN32 no-asm no-idea no-mdc2 no-rc5 --prefix=C:\openssl-%OPENSSL_VERSION%
ECHO 2/6 ....
call ms\do_ms.bat
ECHO 3/6 ....
nmake -f ms\ntdll.mak
ECHO 4/6 ....
nmake -f ms\ntdll.mak install
ECHO 5/6 ....
nmake -f ms\nt.mak
ECHO 6/6 ....
nmake -f ms\nt.mak install