###############################################################################
#### Feature Flags ############################################################
###############################################################################
# This makefile processes feature flags (CKF_*) and adds whatever necessary
# preprocessor definitions are required to turn those features on and off.
#
# The results are stored in four macros:
#   DISABLED_FEATURES       Optional features that have been turned OFF
#   DSIABLED_FEATURE_DEFS   The preprocessor definitions to turn those features
#                           off (eg, -DNO_ENCRYPTION)
#   ENABLED_FEATURES        Optional features that have been turned ON
#   ENABLED_FEATURE_DEFS    The preprocessor definitions to turn those features
#                           on (eg, -DZLIB)
#
# The supported feature flags are:
#   Flag           Default    Description
#   CKF_ZLIB       no         ZLIB support
#   CKF_SSL        no         SSL support
#   CKF_SSH        no         libssh support (built-in SSH)
#   CKF_CONPTY     no         Windows PTY support.
#   CKF_CRYPTDLL   no         Build k95crypt and enable telnet encryption support
#   CKF_DEBUG      yes        Debug logging - on by default
#   CKF_BETATEST   yes        Set to no to do a release build
#   CKF_NO_CRYPTO  no         Disable all cryptography (SSL, SSH, Crypt DLL)
#   CKF_XYZ        no         X/Y/Z MODEM (Relies on the 'P' library)
#   CKF_MOUSEWHEEL yes        Support for the the mouse wheel
#   CKF_NTLM       yes        Windows NTLM support
#   CKF_LOGIN      yes
#   CKT_NT31       no         Target NT 3.1 (Watcom, Visual C++ 1.0/2.0)
#   CKT_NT35       no         Target NT 3.50 (Watcom, Visual C++ 2.0)
#   CKF_TAPI       yes        Modem dialing support
#   CKF_RICHEDIT   yes        Rich Edit control support
#   CKF_TOOLBAR    yes        Include the toolbar
#
# The following flags are set automatically:
#   CKF_SSH     Turned off when targeting OS/2 or when building with OpenWatcom
#   CKF_CONPTY  Turned on when building with MSC >= 192
#   CKF_SSL     Turned off always (SSL support doesn't currently build)
#   CKF_LOGIN   Turned off when building with Visual C++ 5.0 or older
#   CKF_NTLM    Turned off when building with Visual C++ 5.0 or older
#   CKF_DECNET  x86 and Alpha, Windows Server 2003 and older (Visual C++ 2019 and older)
#
# All other flags should be set prior to starting the build, for example:
#   set CKF_DEBUG=no
#   mkg.bat
#------------------------------------------------------------------------------

!message Processing feature flags...

# Network Connections are always supported. We only put it here because
# the Watcom nmake clone can't handle empty macros so we need *something* here.
#ENABLED_FEATURES = Network-Connections
#ENABLED_FEATURE_DEFS = -DNETCONN

#DISABLED_FEATURES =
#DISABLED_FEATURE_DEFS =

# type /interpret doesn't work on windows currently.
DISABLED_FEATURE_DEFS = $(DISABLED_FEATURE_DEFS) -DNOTYPEINTERPRET

!if "$(PLATFORM)" == "NT"
WIN32_VERSION=0x0400

!if "$(CMP)" == "OWCL"
# No built-in SSH support for OpenWatcom (yet)
CKF_SSH=no
!endif

!if ($(MSC_VER) >= 192)
# ConPTY on Windows 10+ requires a Platform SDK from late 2018 or newer.
# So we'll only turn this on automatically when building with Visual C++ 2019 or
# later.
CKF_CONPTY=yes
!endif

!if ($(MSC_VER) <= 110)
# The Platform SDK shipped with Visual C++ 5.0 (Visual Studio 97) and earlier
# doesn't include the necessary headers (security.h, ntsecapi.h, etc) for this
# feature.
CKF_LOGIN=no
CKF_NTLM=no

# Or for scroll wheel support
CKF_MOUSEWHEEL=no

!endif

!if ($(MSC_VER) == 90)
# The Platform SDK shipped with Visual C++ 2.0 lacks quite a lot of stuff
# compared to Visual C++ 4.0 so there is a special target for this level of
# windows.
!message Visual C++ 2.0: setting target to Windows NT 3.50 API level.
# TODO: Audit use of CKT_NT31 and see if any of that stuff should really be CKT_NT35
#CKT_NT31=yes
CKT_NT35=yes

# Setting CKT_NT35 and CKT_NT31 at the same time will result in runtime checks
# for various APIs being compiled in (rather than only the NT 3.50 or NT 3.10
# code being present with no runtime check). Visual C++ 2.0 is currently the
# only version that can target both so we may as well have it on by default.
!if "$(CKT_NT31)" != "no"
!message ...and also the Windows NT 3.10 API
CKT_NT31=yes
!endif

!endif

!if ($(MSC_VER) == 80)
!message Visual C++ 1.0: setting target to Windows NT 3.1 API level.
CKT_NT31=yes
!endif

!if ($(MSC_VER) > 131) && "$(CMP)" == "VCXX"
# OpenWatcom is mostly compatible with Visual C++ 2002 but it doesn't have intptr_t
ENABLED_FEATURE_DEFS = $(ENABLED_FEATURE_DEFS) -DCK_HAVE_INTPTR_T
!endif

# For all versions of windows *EXCEPT* Windows NT 3.1 and 3.50, the target
# minimum version is defined as whatever the compiler happens to support.
# For Windows NT 3.1 and 3.50 the API differences are enough missing APIs
# to require a special macro to exclude references to them. This allows
# NT 3.50 and 3.1 to be targeted with both Visual C++ and OpenWatcom.

!if "$(CKT_NT35)" == "yes"
# These features are available on NT 3.50 but not on NT 3.1
# -> These may appear if/when work to port to NT 3.1 is done.
ENABLED_FEATURE_DEFS = $(ENABLED_FEATURE_DEFS) -DCKT_NT35
!endif

!if "$(CKT_NT31)" == "yes"
# These features are not available on Windows NT 3.50
ENABLED_FEATURE_DEFS = $(ENABLED_FEATURE_DEFS) -DCKT_NT31
RC_FEATURE_DEFS = $(RC_FEATURE_DEFS) /dCKT_NT31
!endif

# These features require Windows NT 3.51 and are unknown to Visual C++ 1.0/2.0
!if "$(CKT_NT35)" == "yes" || "$(CKT_NT31)" == "yes"
CKF_TAPI=no
CKF_RICHEDIT=no
CKF_TOOLBAR=no
CKF_LOGIN=no
CKF_NTLM=no
ENABLED_FEATURE_DEFS = $(ENABLED_FEATURE_DEFS) -DCKT_NT35_OR_31
RC_FEATURE_DEFS = $(RC_FEATURE_DEFS) /dCKT_NT31 /dCKT_NT35_OR_31
!endif

!if "$(CKT_NT35)" == "yes" && "$(CKT_NT31)" == "yes"
ENABLED_FEATURE_DEFS = $(ENABLED_FEATURE_DEFS) -DCKT_NT35_AND_31
!endif

!if "$(CKT_NT31)" == "yes" && "$(CKT_NT35)" != "yes"
# Targeting Windows NT 3.1 only
ENABLED_FEATURE_DEFS = $(ENABLED_FEATURE_DEFS) -DCKT_NT31ONLY
!endif

# CKT_NT31          - Compiled code must work on NT 3.1
# CKT_NT35          - Compiled code must work on NT 3.50
# CKT_NT31ONLY      - NT 3.1 is the only target - must be buildable with
#                     Visual C++ 1.0 32-bit edition. No runtime checks for
#                     available APIs.
# CKT_NT35_AND_31   - Targeting both NT 3.1 and 3.50. Target compiler is
#                     Visual C++ 2.0. Use runtime checks for available APIs where
#                     required.
# CKT_NT35_OR_31    - Targeting NT 3.50 or 3.1 (rather than NT 3.51 or newer).
#                     Target compilers are Visual C++ 1.0 32-bit edition and 2.0.
#                     This is for code that is common to NT 3.1 and 3.50 but not
#                     newer versions of windows.
# None of the above - Targeting NT 3.51 or newer

!else

# OS/2 gets NetBIOS support!
CKF_NETBIOS=yes

# And does not get mouse wheel support (not implemented)
CKF_MOUSEWHEEL=no

!if ("$(CMP)" == "OWCL") || ("$(CMP)" == "OWCL386")
# But not when building with OpenWatcom. At the moment it causes Kermit/2 to
# crash on startup at ckonbi.c:152
!message Turning NetBIOS support off - OpenWatcom builds just crash with it enabled.
CKF_NETBIOS=no

!message Turning X/Y/Z MODEM support off - build errors with OpenWatcom need fixing
CKF_XYZ=no

!message Turning SRP off - no Watcom support for it yet.
CKF_SRP=no
# TODO: Figure out SRP support on OS/2 with OpenWatcom

!endif

!if "$(CKF_SSH)" == "yes"
!message Target platform is OS/2 - forcing SSH off (not supported)
# No built-in SSH support for OS/2 (yet)
CKF_SSH=no
!endif
!endif

!if "$(TARGET_CPU)" == "MIPS"
# "Visual C++ 10.00.5292X for MIPS R-Series" can't build ckntap.c for
# some reason. So just turn TAPI support off. You get errors about illegal
# type conversions and tree nodes not being evaluated.
!message Targeting NT-MIPS: Forcing TAPI support OFF
CKF_TAPI=no
!endif

# Almost certainly won't build
# TODO: Make it build (probably *a lot* of work)
CKF_NT_UNICODE=no

# DECnet requires an x86 or Alpha CPU and is only available on Window Server
# 2003 and older. This means Visual C++ 2019 or older.
!if ("$(TARGET_CPU)" == "x86" || "$(TARGET_CPU)" == "AXP") && $(MSC_VER) < 193
CKF_DECNET=yes
!else
CKF_DECNET=no
!endif

# Other features that should one day be turned on via feature flags once we
# figure out how to build them and get any dependencies sorted out.
#
# SFTP:
#   Turn on with -DSFTP_BUILTIN
#   Requires: reimplementing with libssl (existing implementation relies on the
#             missing OpenSSH bits)

!if "$(CKF_NO_CRYPTO)" == "yes"
# A No-crypto build has been requested regardless of what libraries may have
# been found. Disable all crypto-related features
CKF_SSH=no
CKF_SSL=no
CKF_TELNET_ENCRYPTION=no
CKF_SRP=no
CKF_K4W=no
!endif

# MIT Kerberos for Windows:
#   On by default
#   Turn off with: -DNO_KERBEROS
#   Requires: An antique version of MIT Kerberos for Windows.
#      OR: Rework this to use Heimdal Kerberos
!if "$(CKF_K4W)" == "yes"
# Nothing required - its on by default.
ENABLED_FEATURES = $(ENABLED_FEATURES) Kerberos
!else
DISABLED_FEATURES = $(DISABLED_FEATURES) Kerberos
DISABLED_FEATURE_DEFS = $(DISABLED_FEATURE_DEFS) -DNO_KERBEROS
!endif

# Stanford SRP:
#   On by default
#   Turn off with: -DNO_SRP
!if "$(CKF_SRP)" == "yes"
# Requires Stanford SRP. Tested work version 2.1.2 but older versions may be
# supported with -DPRE_SRP_1_7_3
#
# Ideally SRP functionality would be (optionally) reimplemented using OpenSSL
# which likely has a more up-to-date and secure SRP implementation.
ENABLED_FEATURES = $(ENABLED_FEATURES) SRP

!else
DISABLED_FEATURES = $(DISABLED_FEATURES) SRP
DISABLED_FEATURE_DEFS = $(DISABLED_FEATURE_DEFS) -DNO_SRP
!endif

# ZLIB:
#   Turn on with: -DZLIB
#   Requires: zlib
#             And also some stuff fixed
!if "$(CKF_ZLIB)" == "yes"
!message CKF_ZLIB set - turning ZLIB on.
ENABLED_FEATURES = $(ENABLED_FEATURES) ZLIB
ENABLED_FEATURE_DEFS = $(ENABLED_FEATURE_DEFS) -DZLIB
!else
DISABLED_FEATURES = $(DISABLED_FEATURES) ZLIB
!endif

# SSL:
#   Turn off with: -DNO_SSL
#   Requires: OpenSSL
#             And also some stuff fixed
!if "$(CKF_SSL)" == "yes"

ENABLED_FEATURES = $(ENABLED_FEATURES) SSL

# You can optionally do this to have SSL support loaded at runtime when
# SSLEAY32.DLL can be found. This is not compatible with OpenSSL 1.0.0 or newer
# at this time however - STACK is not defined causing the build to fail in
# ckosslc.c, line 173: void (*p_sk_free)(STACK *)=NULL;
#ENABLED_FEATURE_DEFS = $(ENABLED_FEATURE_DEFS) -DSSLDLL

# No ZLIB? No OpenSSL Compression.
!if "$(CKF_ZLIB)" != "yes"
!message Building without SSL Compression
DISABLED_FEATURE_DEFS = $(DISABLED_FEATURE_DEFS) -DOPENSSL_NO_COMP
!endif

#ENABLED_FEATURE_DEFS = $(ENABLED_FEATURE_DEFS) -DOPENSSL_100

SSL_LIBS=$(CKF_SSL_LIBS)

!else
DISABLED_FEATURES = $(DISABLED_FEATURES) SSL
DISABLED_FEATURE_DEFS = $(DISABLED_FEATURE_DEFS) -DNO_SSL
!endif

# Built-in SSH support (libssh)
#   Turn on with: -DSSHBUILTIN
#   Turn off with: -DNOSSH
#   Requires: libssh
!if "$(CKF_SSH)" == "yes"
!message CKF_SSH set - turning built-in SSH on.
ENABLED_FEATURES = $(ENABLED_FEATURES) SSH
!else
DISABLED_FEATURES = $(DISABLED_FEATURES) SSH
DISABLED_FEATURE_DEFS = $(DISABLED_FEATURE_DEFS) -DNOSSH
!endif

# Windows Pseudoterminal Support (ConPTY)
#   Turn on with: -DCK_CONPTY
#   Requires: Visual C++ 2019 or newer
!if "$(CKF_CONPTY)" == "yes"
ENABLED_FEATURES = $(ENABLED_FEATURES) ConPTY
ENABLED_FEATURE_DEFS = $(ENABLED_FEATURE_DEFS) -DCK_CONPTY
# Needed for STARTUPINFOEX
WIN32_VERSION=0x0600
!else
DISABLED_FEATURES = $(DISABLED_FEATURES) ConPTY
!endif


# Telnet encryption option (DES, CAST)
#   Turn on with: -DCRYPT_DLL
#   Requires: libdes
#     OR: reworking to use OpenSSL instead
#   Turn off with: -DNO_ENCRYPTION
!if "$(CKF_CRYPTDLL)" == "yes"
ENABLED_FEATURES = $(ENABLED_FEATURES) TelnetEncryptionOption CryptDLL
ENABLED_FEATURE_DEFS = $(ENABLED_FEATURE_DEFS) -DCRYPT_DLL -DLIBDES
!else
DISABLED_FEATURES = $(DISABLED_FEATURES) TelnetEncryptionOption CryptDLL
DISABLED_FEATURE_DEFS = $(DISABLED_FEATURE_DEFS) -DNO_ENCRYPTION
!endif

# If beta-test mode hasn't been explicitly turned off then assume its on.
!if "$(CKF_BETATEST)" != "no"
ENABLED_FEATURE_DEFS = $(ENABLED_FEATURE_DEFS) -DBETATEST
!endif

!if "$(CKF_DEBUG)" == "no"
DISABLED_FEATURES = $(DISABLED_FEATURES) Debug
DISABLED_FEATURE_DEFS = $(DISABLED_FEATURE_DEFS) -DNODEBUG
!endif

# XYZMODEM:
#   On by default
#   Turn off with: -DNOCKXYZ
#   Requires: An external library ('P')
# TODO: Test internal XYZ (NOCKXYZ and XYZMODEM undefined)
!if "$(CKF_XYZ)" == "no"
DISABLED_FEATURES = $(DISABLED_FEATURES) XYZMODEM
DISABLED_FEATURE_DEFS = $(DISABLED_FEATURE_DEFS) -DNOCKXYZ
!else
ENABLED_FEATURES = $(ENABLED_FEATURES) XYZMODEM
CKF_XYZ = yes
!endif

# DECnet
#   Turn on with: -DDECNET
#   Requires: Pathworks32 to be installed to use DECnet features
!if "$(CKF_DECNET)" == "no"
DISABLED_FEATURES = $(DISABLED_FEATURES) DECnet
!else
ENABLED_FEATURES = $(ENABLED_FEATURES) DECnet
ENABLED_FEATURE_DEFS = $(ENABLED_FEATURE_DEFS) -DDECNET
!endif

# Meridian SuperLAT
#   Turn on with: -DSUPERLAT
#   Requires: The Meridian SuperLAT SDK
!if "$(CKF_SUPERLAT)" == "yes"
ENABLED_FEATURES = $(ENABLED_FEATURES) SuperLAT
ENABLED_FEATURE_DEFS = $(ENABLED_FEATURE_DEFS) -DSUPERLAT
!else
DISABLED_FEATURES = $(DISABLED_FEATURES) SuperLAT
!endif

# KUI Toolbar:
#   Turn off with: -DNOTOOLBAR
# Removes the toolbar in K95G which requires features unavailable in the version
# of comctl32.dll shipped prior to NT 3.51.
!if "$(CKF_TOOLBAR)" == "no"
DISABLED_FEATURES = $(DISABLED_FEATURES) Toolbar
DISABLED_FEATURE_DEFS = $(DISABLED_FEATURE_DEFS) -DNOTOOLBAR
!endif

# Login:
#   Turn off with: -DNOLOGIN
# Turns authentication for IKS which requires APIs unavailable before NT 3.51.
!if "$(CKF_LOGIN)" == "no"
DISABLED_FEATURES = $(DISABLED_FEATURES) Login
DISABLED_FEATURE_DEFS = $(DISABLED_FEATURE_DEFS) -DNOLOGIN
!endif

# NTLM:
#   Turn off with: -DNONTLM
!if "$(CKF_NTLM)" == "no"
DISABLED_FEATURES = $(DISABLED_FEATURES) NTLM
DISABLED_FEATURE_DEFS = $(DISABLED_FEATURE_DEFS) -DNONTLM
!endif

# TAPI
#   Turn off with -DNODIAL
# Turns off telephony support
!if "$(CKF_TAPI)" == "no"
DISABLED_FEATURES = $(DISABLED_FEATURES) TAPI
DISABLED_FEATURE_DEFS = $(DISABLED_FEATURE_DEFS) -DNODIAL
!endif

# Rich Edit control
#   Turn off with -DNORICHEDIT
# Turns off features relying on the Rich Edit control
!if "$(CKF_RICHEDIT)" == "no"
DISABLED_FEATURES = $(DISABLED_FEATURES) RichEdit
DISABLED_FEATURE_DEFS = $(DISABLED_FEATURE_DEFS) -DNORICHEDIT
!endif


# NetBIOS (for OS/2 only)
#   Turn on with -DCK_NETBIOS
!if ("$(PLATFORM)" == "OS2")
!if ("$(CKF_NETBIOS)" == "yes")
ENABLED_FEATURES = $(ENABLED_FEATURES) NetBIOS
ENABLED_FEATURE_DEFS = $(ENABLED_FEATURE_DEFS) -DCK_NETBIOS
!else
DISABLED_FEATURES = $(DISABLED_FEATURES) NetBIOS
!endif
!endif

# Mouse Wheel support
#   Turn off with -DNOSCROLLWHEEL
# Turns off "set mouse wheel" command along with the ability to scroll
# the terminal or do other things with the mouse wheel
!if "$(CKF_MOUSEWHEEL)" == "no"
DISABLED_FEATURES = $(DISABLED_FEATURES) Mouse-Wheel
DISABLED_FEATURE_DEFS = $(DISABLED_FEATURE_DEFS) -DNOSCROLLWHEEL
!endif

# Windows NT Unicode build
# Turn on with: -DCK_NT_UNICODE : tell C-Kermit we're targeting NT with Unicode
#               -DUNICODE : tell the win32 headers we want Unicode APIs
#               -D_UNICODE : tell the C Runtime we want Unicode APIs
# Targets Windows NT using Unicode APIs. This will allow using Unicode filenames
# and anywhere else you may want to pass unicode strings into (or get unicode
# strings from) Windows.
#
# Windows 9x doesn't support the Unicode APIs so binaries built with this
# enabled won't work on Windows 9x unless also built against the Microsoft Layer
# for Unicode (UNICOWS.DLL) which is available starting from the Windows XP RC1
# version of the Platform SDK. UNICOWS.DLL also apparently has some licensing
# issues (see: https://libunicows.sourceforge.net/) so using Opencow
# (https://opencow.sourceforge.net/) may be more desirable.
#
# Note that CKW will *NOT* actually build with this option enabled at this time.
# Work still needs to be done to:
#   - Adjust all GetProcAddress calls to get either the A or W version of an API
#     depending on if CK_NT_UNICODE is defined (UNICODE can't be relied on as
#     C-Kermit headers define it)
#   - Check all other API calls are using TCHAR and LPTSTR instead of CHAR/LPSTR
#   - Ensure everywhere strings coming from windows are being passed will handle
#     being passed a unicode string (eg, sprintf vs swprintf) without breaking
#     OS/2 or non-unicode (ANSI) Win32 builds.
#   - Fix all the bugs that will most surely appear
# This is probably only worth pursuing if it won't have a major impact on the
# C-Kermit bits that are shared with UNIX/VMS/etc.
!if "$(CKF_NT_UNICODE)" == "yes"
ENABLED_FEATURES = $(ENABLED_FEATURES) Windows-Unicode
ENABLED_FEATURE_DEFS = $(ENABLED_FEATURE_DEFS) -DCK_NT_UNICODE -DUNICODE -D_UNICODE
!endif
