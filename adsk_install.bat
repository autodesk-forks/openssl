@echo off

:: Parse in command line arguments.
if /I "%1" NEQ "x64" if /I "%1" NEQ "x86" goto :usage
if /I "%2" NEQ "vc9" if /I "%2" NEQ "vc10" if /I "%2" NEQ "vc11" if /I "%2" NEQ "vc14" goto :usage

:: Set internal variables.
set _cfg=amd64
set _ver=%2
set _tgt=stage\binary\win_%_ver%

if "%1" == "x86" set _cfg=x86

if "%_ver%" == "vc9" set VSCOMNTOOLS=%VS90COMNTOOLS%
if "%_ver%" == "vc10" set VSCOMNTOOLS=%VS100COMNTOOLS%
if "%_ver%" == "vc11" set VSCOMNTOOLS=%VS110COMNTOOLS%
if "%_ver%" == "vc14" set VSCOMNTOOLS=%VS140COMNTOOLS%


:: Set the VC build environment.
if "%VSINSTALLDIR%" == "" call "%VSCOMNTOOLS%\vsvars32.bat"
call "%VCINSTALLDIR%\vcvarsall.bat" %_cfg%

if "%_cfg%" == "x86" goto :build_win32

:: Build (Debug and release, with infix).

rd /s/q inc64
rd /s/q out64dll
rd /s/q tmp64dll

Perl Configure no-idea no-mdc2 no-rc5 no-ssl2 no-ssl3 VC-WIN64A --infix=_Ad_
call ms\do_win64a
nmake -f ms\ntdll.mak

rd /s/q %_tgt%\x64
md %_tgt%\x64\bin
md %_tgt%\x64\lib

xcopy /y/q/d/r/i out64dll\libeay32_Ad_1.dll %_tgt%\x64\bin
xcopy /y/q/d/r/i out64dll\ssleay32_Ad_1.dll %_tgt%\x64\bin
xcopy /y/q/d/r/i out64dll\libeay32_Ad_1.lib %_tgt%\x64\lib
xcopy /y/q/d/r/i out64dll\ssleay32_Ad_1.lib %_tgt%\x64\lib
xcopy /y/q/d/r/i out64dll\libeay32_Ad_1.pdb %_tgt%\x64\lib
xcopy /y/q/d/r/i out64dll\ssleay32_Ad_1.pdb %_tgt%\x64\lib
xcopy /y/q/d/r/i out64dll\openssl.exe %_tgt%\x64\bin


rd /s/q inc64.dbg
rd /s/q out64dll.dbg
rd /s/q tmp64dll.dbg

Perl Configure no-idea no-mdc2 no-rc5 no-ssl2 no-ssl3 debug-VC-WIN64A --infix=_Ad_
call ms\do_win64a
nmake -f ms\ntdll.mak

xcopy /y/q/d/r/i out64dll.dbg\libeay32_Ad_d1.dll %_tgt%\x64\bin
xcopy /y/q/d/r/i out64dll.dbg\ssleay32_Ad_d1.dll %_tgt%\x64\bin
xcopy /y/q/d/r/i out64dll.dbg\libeay32_Ad_d1.lib %_tgt%\x64\lib
xcopy /y/q/d/r/i out64dll.dbg\ssleay32_Ad_d1.lib %_tgt%\x64\lib
xcopy /y/q/d/r/i out64dll.dbg\libeay32_Ad_d1.pdb %_tgt%\x64\lib
xcopy /y/q/d/r/i out64dll.dbg\ssleay32_Ad_d1.pdb %_tgt%\x64\lib

goto :copy_headers

:build_win32

rd /s/q inc32
rd /s/q out32dll
rd /s/q tmp32dll

Perl Configure no-idea no-mdc2 no-rc5 no-ssl2 no-ssl3 VC-WIN32 no-asm --infix=_Ad_
call ms\do_ms
nmake -f ms\ntdll.mak

rd /s/q %_tgt%\x86
md %_tgt%\x86\bin
md %_tgt%\x86\lib

xcopy /y/q/d/r/i out32dll\libeay32_Ad_1.dll %_tgt%\x86\bin
xcopy /y/q/d/r/i out32dll\ssleay32_Ad_1.dll %_tgt%\x86\bin
xcopy /y/q/d/r/i out32dll\libeay32_Ad_1.lib %_tgt%\x86\lib
xcopy /y/q/d/r/i out32dll\ssleay32_Ad_1.lib %_tgt%\x86\lib
xcopy /y/q/d/r/i out32dll\libeay32_Ad_1.pdb %_tgt%\x86\lib
xcopy /y/q/d/r/i out32dll\ssleay32_Ad_1.pdb %_tgt%\x86\lib
xcopy /y/q/d/r/i out32dll\openssl.exe %_tgt%\x86\bin


rd /s/q inc32.dbg
rd /s/q out32dll.dbg
rd /s/q tmp32dll.dbg

Perl Configure no-idea no-mdc2 no-rc5 no-ssl2 no-ssl3 debug-VC-WIN32 no-asm --infix=_Ad_
call ms\do_ms
nmake -f ms\ntdll.mak

xcopy /y/q/d/r/i out32dll.dbg\libeay32_Ad_d1.dll %_tgt%\x86\bin
xcopy /y/q/d/r/i out32dll.dbg\ssleay32_Ad_d1.dll %_tgt%\x86\bin
xcopy /y/q/d/r/i out32dll.dbg\libeay32_Ad_d1.lib %_tgt%\x86\lib
xcopy /y/q/d/r/i out32dll.dbg\ssleay32_Ad_d1.lib %_tgt%\x86\lib
xcopy /y/q/d/r/i out32dll.dbg\libeay32_Ad_d1.pdb %_tgt%\x86\lib
xcopy /y/q/d/r/i out32dll.dbg\ssleay32_Ad_d1.pdb %_tgt%\x86\lib

:copy_headers

rd /s/q stage\include
rd /s/q stage\src
xcopy /y/q/d/r/i inc32\openssl\*.* stage\include\openssl
xcopy /s/y/q/d/r/i crypto\*.h stage\src\crypto
xcopy /s/y/q/d/r/i engines\*.h stage\src\engines
xcopy /s/y/q/d/r/i ms\*.h stage\src\ms
xcopy /s/y/q/d/r/i ssl\*.h stage\src\ssl

rd /s/q stage\src\crypto\idea
rd /s/q stage\src\crypto\mdc2
rd /s/q stage\src\crypto\rc5

goto :eof

:usage
echo "Usage:	adsk_install.bat {x64|x86} {vc9|vc10|vc11|vc14}"

:eof
