Prerequisite:
	a.	Ensure Perl is installed. You can get it from http://www.perl.org/.
	b.	Ensure Visual Studio (2008/2010/2012/2015) with latest update is installed.

Build new OpenSSL binaries (VS/2008/VS2010/VS2012/VS2015):
	a.	Run adsk_install.bat and follow the usage.
	b.	All output will go to "stage" subfolder that are ready for verify/sign/p4submit.





================================================================================
Additional details on build process (Only for record).
******************************** NOTE ******************************************
Following section must not be followed if adsk_install.bat runs successfully.
--------------------------------------------------------------------------------

Build new OpenSSL 1.0.1l binaries (VS2010/VS2012) requires following operation:
	a.	Get OpenSSL source code from //depot/external_toolkit_source/openssl/1.0.1l/ to your local folder such as "C:\SSD_1\external_toolkit_source\openssl\1.0.1l".
		i.	Make the folder and subfolders writable.
	b.	Remove inc32, inc64, out32dll, out32dll.dbg, out64dll, out64dll.dbg, tmp32dll, tmp32dll.dbg, tmp64dll, tmp64dll.dbg folders.
	c.	Create OpenSSL binaries folder structure like what we did for //depot/PlatformSDK/external/openssl/1.0.1l/ under some other folder such as "c:\SSD_1\external\openssl\1.0.1l\", and we will put the binaries to those folders in later steps. And we will check in all the items in those folders to P4 later.
	d.	Build x86 binaries.
		i.	Launch VS x86 Command Prompt.
			*	For VS2010: Visual Studio Command Prompt.
			*	For VS2012: VS2012 x86 Native Tools Command Prompt.
		ii.	Use 'cd' command change the current directory to the OpenSSL source dir, such as "cd c:\SSD_1\external_toolkit_source\openssl\1.0.1l".
		iii.	Run command:
			*	Build with SSL2/SSL3 support: Run 'Perl Configure no-idea no-mdc2 no-rc5 VC-WIN32 no-asm --infix=_Ad_'.
			*	Build without SSL2/SSL3 support: Run 'Perl Configure no-idea no-mdc2 no-rc5 no-ssl2 no-ssl3 VC-WIN32 no-asm --infix=_Ad_'.
			*	For debug build:
				*	Build with SSL2/SSL3 support: Run 'Perl Configure no-idea no-mdc2 no-rc5 debug-VC-WIN32 no-asm --infix=_Ad_'.
				*	Build without SSL2/SSL3 support: Run 'Perl Configure no-idea no-mdc2 no-rc5 no-ssl2 no-ssl3 debug-VC-WIN32 no-asm --infix=_Ad_'.
		iv.	Run command 'ms\do_ms'.
		v.	Run command 'nmake -f ms\ntdll.mak'.
		vi.	Copy libeay32_Ad_(d)1.dll, openssl.exe and ssleay32_Ad_(d)1.dll from 'openssl\1.0.1l\out32dll' and 'openssl\1.0.1l\out32dll.dbg' to the binary folder you created in step c such as "c:\SSD_1\external\openssl\1.0.1l\binary\win_vc11\x86\bin\" (or "c:\SSD_1\external\openssl\1.0.1l\binary\win_vc10\x86\bin\" for VS2010).
		vii.	Copy libeay32_Ad_(d)1.lib, libeay32_Ad_(d)1.pdb, ssleay32_Ad_(d)1.lib, ssleay32_Ad_(d)1.pdb from 'openssl\1.0.1l\out32dll' and 'openssl\1.0.1l\out32dll.dbg' to the lib folder you created in step c such as "c:\SSD_1\external\openssl\1.0.1l\binary\win_vc11\x86\lib\" (or "c:\SSD_1\external\openssl\1.0.1l\binary\win_vc10\x86\lib\" for VS2010).
	e.	Build x64 binaries.
		i.	Launch VS x64 Command Prompt.
			*	For VS2010: Visual Studio x64 Win64 Command Prompt.
			*	For VS2012: VS2012 x64 Cross Tools Command Prompt.
		ii.	Use 'cd' command change the current directory to the OpenSSL source dir, such as "cd c:\SSD_1\external_toolkit_source\openssl\1.0.1l".
		iii.	Run command:
			*	Build with SSL2/SSL3 support: Run 'Perl Configure no-idea no-mdc2 no-rc5 VC-WIN64A --infix=_Ad_'.
			*	Build without SSL2/SSL3 support: Run 'Perl Configure no-idea no-mdc2 no-rc5 no-ssl2 no-ssl3 VC-WIN64A --infix=_Ad_'.
			*	For debug build:
				*	Build with SSL2/SSL3 support: Run 'Perl Configure no-idea no-mdc2 no-rc5 debug-VC-WIN64A --infix=_Ad_'.
				*	Build without SSL2/SSL3 support: Run 'Perl Configure no-idea no-mdc2 no-rc5 no-ssl2 no-ssl3 debug-VC-WIN64A --infix=_Ad_'.

		iv.	Run command 'ms\do_win64a'.
		v.	Run command 'nmake -f ms\ntdll.mak'.
		vi.	Copy libeay32_Ad_(d)1.dll, openssl.exe and ssleay32_Ad_(d)1.dll from 'openssl\1.0.1l\out64dll' and 'openssl\1.0.1l\out64dll.dbg' to the binary folder you created in step c such as "c:\SSD_1\external\openssl\1.0.1l\binary\win_vc11\x64\bin\" (or "c:\SSD_1\external\openssl\1.0.1l\binary\win_vc10\x64\bin\" for VS2010).
		vii.	Copy libeay32_Ad_(d)1.lib, libeay32_Ad_(d)1.pdb, ssleay32_Ad_(d)1.lib, ssleay32_Ad_(d)1.pdb from 'openssl\1.0.1l\out64dll' and 'openssl\1.0.1l\out64dll.dbg' to the lib folder you created in step c such as "c:\SSD_1\external\openssl\1.0.1l\binary\win_vc11\x64\lib\" (or "c:\SSD_1\external\openssl\1.0.1l\binary\win_vc10\x64\lib\" for VS2010).
	f.	Copy all the files from openssl\1.0.1l\inc32\openssl folder to include\openssl folder you created in step c such as "c:\SSD_1\external\openssl\1.0.1l\include\openssl\".
		i.	Include 'applink.c'.
	g.	Copy all the headers file from openssl\1.0.1l\crypto, openssl\1.0.1l\engines, openssl\1.0.1l\ms, openssl\1.0.1l\ssl folder to related subfolder of src folder you created in step c such as "c:\SSD_1\external\openssl\1.0.1l\src\".
		i.	Exclude 'idea', 'mdc2', 'rc5' subfolders from 'openssl\1.0.1l\crypto'.

