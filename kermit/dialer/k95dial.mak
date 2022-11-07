# K95 Dialer makefile

#    nmake -f k95dial.mak winnt       
#    nmake -f k95dial.mak os2      

# Be sure to set the LIB and INCLUDE environment variables for Zinc, e.g.:
#    set INCLUDE=.;C:\ZINC\INCLUDE;C:\MSVC\INCLUDE
#    set LIB=.;C:\ZINC\LIB\MVCPP400;C:\MSVC\LIB

# TODO: We should only do this on Windows.
#!if "$(PLATFORM)" == "NT"
!message Attempting to detect compiler...
!include ..\k95\compiler_detect.mak
#!endif

!message
!message
!message ===============================================================================
!message C-Kermit Dialer Build Configuration
!message ===============================================================================
!message  Architecture:             $(TARGET_CPU)
!message  Compiler:                 $(COMPILER)
!message  Compiler Version:         $(COMPILER_VERSION)
!message  Compiler Target Platform: $(TARGET_PLATFORM)
!message ===============================================================================
!message
!message

# ----- Windows NT compiler options -----------------------------------------
# for debug:    add /Zi to CPP_OPTS
#               add /DEBUG:MAPPED,FULL /DEBUGTYPE:CV to LINK_OPTS
WNT_CPP=cl
WNT_LINK=link
WNT_LIBRARIAN=lib

WNT_CPP_OPTS= -c -W3 -MT -DWIN32 -DOS2 -DNT -DCKODIALER -I..\k95 -noBool
!if $(MSC_VER) < 100
# Visual C++ 2.0 or older
WNT_CPP_OPTS=$(WNT_CPP_OPTS) -DNODIAL -DCKT_NT31
!endif

!if "$(CMP)" == "OWCL"
# The OpenWatcom 1.9 linker fails with an internal error using the normal linker options.
WNT_LINK_OPTS=-subsystem:windows /MAP
!else
WNT_LINK_OPTS=-subsystem:windows -entry:WinMainCRTStartup /MAP /NODEFAULTLIB:libc
!endif
#WNT_CPP_OPTS= -c -W3 -MT -DWIN32 -DOS2 -DNT -I..\k95 /Zi -noBool
#WNT_LINK_OPTS=-align:0x1000 -subsystem:windows -entry:WinMainCRTStartup /MAP /NODEFAULTLIB:libc /Debug:full /Debugtype:cv 
WNT_CON_LINK_OPTS=-subsystem:console -entry:mainCRTStartup
WNT_LIB_OPTS=/machine:i386 /subsystem:WINDOWS

WNT_OBJS=
WNT_LIBS=libcmt.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib winspool.lib wnt_zil.lib ndirect.lib nservice.lib nstorage.lib oldnames.lib shell32.lib ole32.lib uuid.lib advapi32.lib # compmgr.lib

!if $(MSC_VER) < 130
!message Using ctl3d32
# CTL3D32 is only available on Visual C++ 6.0 and earlier. Visual C++ 2002 and
# OpenWatcom (which we pretend is VC++ 2002) do not have it.
WNT_LIBS=$(WNT_LIBS) ctl3d32.lib
!endif

WNT_CON_LIBS=libc.lib kernel32.lib w32_zil.lib ndirect.lib nservice.lib nstorage.lib oldnames.lib
.cpp.obn:
	$(WNT_CPP) $(WNT_CPP_OPTS) -Fo$*.obn $<

.c.obn:
	$(WNT_CPP) $(WNT_CPP_OPTS) -Fo$*.obn $<

# ----- OS/2 compiler options -----------------------------------------------
OS2_CPP=icc
OS2_LINK=ilink
OS2_LIBRARIAN=ilib
OS2_RC=rc

# ----- Compile, Link, and Lib options --------------------------------------
#OS2_CPP_OPTS=/c /D__OS2__ /DOS2 /Gx+ /Sp1 /Ti+ /Tm+ /Tx+ -D_DEBUG
#OS2_LINK_OPTS=/BASE:0x10000 /PM:PM /NOI /NOE /debug 
# ----- Next line for pre-compiled headers ----------------------------------
#OS2_CPP_OPTS=/c /D__OS2__ /DOS2 /Gx+ /Sp1 /FiZIL.SYM /SiZIL.SYM
#OS2_LINK_OPTS=/BASE:0x10000 /PM:PM /NOI /NOE 
# ----- Next line for pre-compiled headers and optimization -----------------
OS2_CPP_OPTS=/c /D__OS2__ /DOS2 /DCKODIALER /Gx+ /Sp1 -Sm -G5 -Gt -Gd- -Gn+ -J -Fi+ -Si+ -Gi+ -Gl+ -O -Oi25 -Gm
OS2_LINK_OPTS=/BASE:0x10000 /PM:PM /NOI /NOE 
OS2_LIB_OPTS=
OS2_RC_OPTS=

OS2_OBJS=
OS2_LIBS=os2_zil.lib odirect.lib oservice.lib ostorage.lib

.SUFFIXES : .cpp .c

.c.obo:
	$(OS2_CPP) $(OS2_CPP_OPTS) -Fo$*.obo $<

.cpp.obo:
	$(OS2_CPP) $(OS2_CPP_OPTS) /Fo$*.obo $<

# ----- Usage --------------------------------------------------------------
usage:
	@echo ...........
	@echo ...........
	@echo To make the K95 Dialer type:
	@echo nmake -f k95dial.mak winnt
	@echo nmake -f k95dial.mak win32
	@echo nmake -f k95dial.mak os2
	@echo ...........
	@echo ...........

# ----- Clean ---------------------------------------------------------------
clean:
	z_clean

# ----- Windows NT ----------------------------------------------------------
winnt: nckdial.exe 

nckdial.exe: main.obn dialer.obn lstitm.obn kconnect.obn \
            kdialopt.obn kquick.obn kdconfig.obn kcolor.obn nk95dial.res dialetc.obn \
            kdirnet.obn kdirdial.obn kabout.obn kdemo.obn kstatus.obn kwinmgr.obn ktapi.obn \
            klocation.obn kmodem.obn kmdmdlg.obn kappl.obn ksetgeneral.obn \
            ksetterminal.obn ksetxfer.obn ksetserial.obn ksettelnet.obn \
            ksetkerberos.obn ksettls.obn ksetkeyboard.obn ksetlogin.obn \
            ksetprinter.obn ksetlogs.obn ksetssh.obn ksetftp.obn ksetgui.obn \
            ksetdlg.obn ksettcp.obn
	$(WNT_LINK) $(WNT_LINK_OPTS) -out:nk95dial.exe $(WNT_OBJS) \
    main.obn dialer.obn lstitm.obn kconnect.obn kdialopt.obn kquick.obn kdconfig.obn\
    kcolor.obn nk95dial.res dialetc.obn kdirnet.obn kdirdial.obn kdemo.obn kabout.obn kstatus.obn\
    kwinmgr.obn klocation.obn ktapi.obn kmodem.obn kmdmdlg.obn kappl.obn ksetgeneral.obn \
    ksetterminal.obn ksetxfer.obn ksetserial.obn  ksettelnet.obn ksetkerberos.obn \
    ksettls.obn ksetkeyboard.obn ksetlogin.obn ksetprinter.obn ksetlogs.obn \
    ksetssh.obn ksetgui.obn ksetftp.obn ksetdlg.obn ksettcp.obn \
    $(WNT_LIBS)

nk95dial.res: k95dial.rc k95f.ico
    rc -v -fo nk95dial.res k95dial.rc

main.obn: main.cpp dialer.hpp kconnect.hpp kwinmgr.hpp kdemo.hpp

dialer.obn: dialer.cpp dialer.hpp

lstitm.obn: lstitm.cpp lstitm.hpp usermsg.hpp kstatus.hpp kmdminf.h

klocation.obn: klocation.cpp klocation.hpp usermsg.hpp kstatus.hpp \

kmodem.obn: kmodem.cpp kmodem.hpp usermsg.hpp kstatus.hpp

kconnect.obn: kconnect.cpp kconnect.hpp dialer.hpp lstitm.hpp \
              kdialopt.hpp kquick.hpp usermsg.hpp kdconfig.hpp kdirnet.hpp kdirdial.hpp\
              kabout.hpp kstatus.hpp klocation.hpp kmdmdlg.hpp kmodem.hpp kmdminf.h \
              kappl.hpp ksetgeneral.hpp ksetterminal.hpp ksetxfer.hpp ksetserial.hpp \
              ksettelnet.hpp ksetkerberos.hpp ksettls.hpp ksetkeyboard.hpp ksetlogin.hpp \
              ksetprinter.hpp ksetlogs.hpp ksetssh.hpp ksetftp.hpp ksetgui.hpp ksettcp.hpp

kwinmgr.obn:  kwinmgr.cpp kwinmgr.hpp 

ksetgeneral.obn: ksetgeneral.cpp ksetgeneral.hpp dialer.hpp lstitm.hpp kconnect.hpp \
        usermsg.hpp 

ksetterminal.obn: ksetterminal.cpp ksetterminal.hpp dialer.hpp lstitm.hpp kconnect.hpp \
        usermsg.hpp kcolor.hpp

ksetxfer.obn: ksetxfer.cpp ksetxfer.hpp dialer.hpp lstitm.hpp kconnect.hpp \
        usermsg.hpp 

ksetserial.obn: ksetserial.cpp ksetserial.hpp dialer.hpp lstitm.hpp kconnect.hpp \
        usermsg.hpp 

ksettelnet.obn: ksettelnet.cpp ksettelnet.hpp dialer.hpp lstitm.hpp kconnect.hpp \
        usermsg.hpp 

ksettcp.obn: ksettcp.cpp ksettcp.hpp dialer.hpp lstitm.hpp kconnect.hpp \
        usermsg.hpp 

ksettls.obn: ksettls.cpp ksettls.hpp dialer.hpp lstitm.hpp kconnect.hpp \
        usermsg.hpp 

ksetlogs.obn: ksetlogs.cpp ksetlogs.hpp dialer.hpp lstitm.hpp kconnect.hpp \
        usermsg.hpp 

ksetgui.obn: ksetgui.cpp ksetgui.hpp dialer.hpp lstitm.hpp kconnect.hpp \
        usermsg.hpp 

ksetdlg.obn: ksetdlg.cpp ksetdlg.hpp

ksetssh.obn: ksetssh.cpp ksetssh.hpp dialer.hpp lstitm.hpp kconnect.hpp \
        usermsg.hpp 

ksetftp.obn: ksetftp.cpp ksetftp.hpp dialer.hpp lstitm.hpp kconnect.hpp \
        usermsg.hpp 

ksetprinter.obn: ksetprinter.cpp ksetprinter.hpp dialer.hpp lstitm.hpp kconnect.hpp \
        usermsg.hpp 

ksetlogin.obn: ksetlogin.cpp ksetlogin.hpp dialer.hpp lstitm.hpp kconnect.hpp \
        usermsg.hpp 

ksetkeyboard.obn: ksetkeyboard.cpp ksetkeyboard.hpp dialer.hpp lstitm.hpp kconnect.hpp \
        usermsg.hpp 

ksetkerberos.obn: ksetkerberos.cpp ksetkerberos.hpp dialer.hpp lstitm.hpp kconnect.hpp \
        usermsg.hpp 

kdialopt.obn: kdialopt.cpp kdialopt.hpp dialer.hpp usermsg.hpp klocation.hpp

kmdmdlg.obn: kmdmdlg.cpp kmdmdlg.hpp dialer.hpp usermsg.hpp kmodem.hpp

kquick.obn: kquick.cpp kquick.hpp dialer.hpp usermsg.hpp kstatus.hpp

kdconfig.obn: kdconfig.cpp kdconfig.hpp usermsg.hpp

kcolor.obn: kcolor.cpp kcolor.hpp

dialetc.obn: dialetc.c ..\k95\ckoetc.h

ktapi.obn: ktapi.c ktapi.h ..\k95\ckcdeb.h ..\k95\ckcker.h ..\k95\ckucmd.h ..\k95\ckuusr.h \
	   ..\k95\ckowin.h ..\k95\cknwin.h kconnect.hpp

kappl.obn:  kappl.cpp kappl.hpp kdconfig.hpp dialer.hpp

kdirdial.obn:  kdirdial.cpp kdirdial.hpp dialer.hpp

kdirnet.obn: kdirnet.cpp kdirnet.hpp dialer.hpp

kabout.obn: kabout.cpp kabout.hpp dialer.hpp

kdemo.obn: kdemo.cpp kdemo.hpp dialer.hpp

kstatus.obn: kstatus.cpp kstatus.hpp

# ----- OS/2 ----------------------------------------------------------
os2: k2dial.exe

k2dial.exe: main.obo dialer.obo lstitm.obo kconnect.obo \
            kdialopt.obo kquick.obo kdconfig.obo kcolor.obo dialetc.obo \
            kdirnet.obo kdirdial.obo kdemo.obo kstatus.obo kwinmgr.obo \
            klocation.obo kmodem.obo kmdmdlg.obo kappl.obo ksetgeneral.obo \
            ksetterminal.obo ksetxfer.obo ksetserial.obo ksettelnet.obo \
            ksetkerberos.obo ksettls.obo ksetkeyboard.obo ksetlogin.obo \
            ksetprinter.obo ksetlogs.obo ksetssh.obo ksetftp.obo ksetgui.obo \
            ksetdlg.obo kabout.obo ksettcp.obo os2.def k2dial.rc
	$(OS2_LINK) $(OS2_LINK_OPTS) -out:k2dial.exe \
    main.obo dialer.obo lstitm.obo kconnect.obo kdialopt.obo kquick.obo kdconfig.obo\
    kcolor.obo dialetc.obo kdirnet.obo kdirdial.obo kdemo.obo kstatus.obo kwinmgr.obo \
    klocation.obo kmodem.obo kmdmdlg.obo kappl.obo ksetgeneral.obo \
    ksetterminal.obo ksetxfer.obo ksetserial.obo  ksettelnet.obo ksetkerberos.obo \
    ksettls.obo ksetkeyboard.obo ksetlogin.obo ksetprinter.obo ksetlogs.obo \
    ksetssh.obo ksetgui.obo ksetftp.obo ksetdlg.obo kabout.obo ksettcp.obo os2.def $(OS2_LIBS)
    rc k2dial.rc k2dial.exe 

main.obo: main.cpp dialer.hpp kconnect.hpp kwinmgr.hpp

dialer.obo: dialer.cpp dialer.hpp

lstitm.obo: lstitm.cpp lstitm.hpp usermsg.hpp kstatus.hpp kmdminf.h

kconnect.obo: kconnect.cpp kconnect.hpp dialer.hpp lstitm.hpp \
              kdialopt.hpp kquick.hpp usermsg.hpp kdconfig.hpp kdirnet.hpp kdirdial.hpp\
              kdemo.hpp kstatus.hpp kmdminf.h kappl.hpp ksetgeneral.hpp

kappl.obo:  kappl.cpp kappl.hpp dialer.hpp

kwinmgr.obo:  kwinmgr.cpp kwinmgr.hpp 

ksetgeneral.obo: ksetgeneral.cpp ksetgeneral.hpp dialer.hpp lstitm.hpp kconnect.hpp \
        usermsg.hpp 

ksetterminal.obo: ksetterminal.cpp ksetterminal.hpp dialer.hpp lstitm.hpp kconnect.hpp \
        usermsg.hpp kcolor.hpp

ksetxfer.obo: ksetxfer.cpp ksetxfer.hpp dialer.hpp lstitm.hpp kconnect.hpp \
        usermsg.hpp 

ksetserial.obo: ksetserial.cpp ksetserial.hpp dialer.hpp lstitm.hpp kconnect.hpp \
        usermsg.hpp 

ksettelnet.obo: ksettelnet.cpp ksettelnet.hpp dialer.hpp lstitm.hpp kconnect.hpp \
        usermsg.hpp 

ksettls.obo: ksettls.cpp ksettls.hpp dialer.hpp lstitm.hpp kconnect.hpp \
        usermsg.hpp 

ksetlogs.obo: ksetlogs.cpp ksetlogs.hpp dialer.hpp lstitm.hpp kconnect.hpp \
        usermsg.hpp 

ksetgui.obo: ksetgui.cpp ksetgui.hpp dialer.hpp lstitm.hpp kconnect.hpp \
        usermsg.hpp 

ksetdlg.obo: ksetdlg.cpp ksetdlg.hpp

ksetssh.obo: ksetssh.cpp ksetssh.hpp dialer.hpp lstitm.hpp kconnect.hpp \
        usermsg.hpp 

ksetftp.obo: ksetftp.cpp ksetftp.hpp dialer.hpp lstitm.hpp kconnect.hpp \
        usermsg.hpp 

ksetprinter.obo: ksetprinter.cpp ksetprinter.hpp dialer.hpp lstitm.hpp kconnect.hpp \
        usermsg.hpp 

ksetlogin.obo: ksetlogin.cpp ksetlogin.hpp dialer.hpp lstitm.hpp kconnect.hpp \
        usermsg.hpp 

ksetkeyboard.obo: ksetkeyboard.cpp ksetkeyboard.hpp dialer.hpp lstitm.hpp kconnect.hpp \
        usermsg.hpp 

ksetkerberos.obo: ksetkerberos.cpp ksetkerberos.hpp dialer.hpp lstitm.hpp kconnect.hpp \
        usermsg.hpp 


kdialopt.obo: kdialopt.cpp kdialopt.hpp dialer.hpp usermsg.hpp klocation.hpp

kquick.obo: kquick.cpp kquick.hpp dialer.hpp usermsg.hpp kstatus.hpp

kdconfig.obo: kdconfig.cpp kdconfig.hpp usermsg.hpp

kcolor.obo: kcolor.cpp kcolor.hpp

dialetc.obo: dialetc.c ..\ckoetc.h

kdirdial.obo:  kdirdial.cpp kdirdial.hpp dialer.hpp

kdirnet.obo: kdirnet.cpp kdirnet.hpp dialer.hpp

kdemo.obo: kdemo.cpp kdemo.hpp dialer.hpp

kstatus.obo: kstatus.cpp kstatus.hpp

klocation.obo: klocation.cpp klocation.hpp usermsg.hpp kstatus.hpp

kmodem.obo: kmodem.cpp kmodem.hpp usermsg.hpp kstatus.hpp

kmdmdlg.obo: kmdmdlg.cpp kmdmdlg.hpp dialer.hpp usermsg.hpp kmodem.hpp

kabout.obo: kabout.cpp kabout.hpp dialer.hpp

ksettcp.obo: ksettcp.cpp ksettcp.hpp dialer.hpp lstitm.hpp kconnect.hpp \
        usermsg.hpp 

