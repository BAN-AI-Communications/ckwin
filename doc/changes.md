# Change Log
This document covers what has changed in each release of C-Kermit for Windows 
(formerly known as Kermit 95). For a more in-depth look at what has changed, 
check the git commit log.

## C-Kermit for Windows 10.0b8 beta 4 - 15 December 2022
This release is mostly a collection of minor improvements and bug fixes as I
have been unexpectedly busy since the prior release resulting in the schedule
slipping somewhat.

### Things to be aware of when upgrading
* The third mouse button is now supported in k95g which may affect any scripts
  you have that map mouse buttons. On a three button mouse:
    * Previously: Left was button 1, Middle was unsupported, Right was button 2
    * Now: Left is button 1, Middle is button 2, Right is button 3
* Updates to the Dialer to support new SSH settings have resulted in the version
  number for the dialer data file being bumped. It is advised you take a backup
  of your existing data file before running the new version of the dialer for
  the first time.
    * On first start, your data file(s) will be upgraded to the new format
    * SSH connection scripts generated by the new dialer will not be compatible
      with Kermit 95 due to a difference in supported SSH options.

### New Features:
* Upgraded from C-Kermit 10.0 beta.04 to beta.07, plus beta.08 changes from
  the 11th and 12th of December 2022.
    * [New in C-Kermit 10.0 Beta.05](https://kermitproject.org/ckupdates.html#ck100beta05) 
    * [New in C-Kermit 10.0 Beta.06](https://kermitproject.org/ckupdates.html#ck100beta06)
    * [New in C-Kermit 10.0 Beta.07](https://kermitproject.org/ckupdates.html#ck10beta07)
    * [New in C-Kermit 10.0 Beta.08](https://kermitproject.org/ckupdates.html#ck10beta08)
      (Only up to and including 12 December 2022)
* The default `k95custom.ini` now outputs a message on startup directing new 
  users to have a look at and optionally customise the file
* X/Y/Z MODEM support is back thanks to Jyrki Salmi of Online Solutions Oy 
  (www.online.fi) providing his "P" X/Y/Z MODEM library under the same license 
  as C-Kermit for Windows
* Terminal mouse reporting
    * X10 protocol (send button + coordinates on mouse down) supported for Linux 
      and ANSI terminal types
    * X11/Normal, URXVT and SGR protocols (send button + modifiers + coordinates 
      on mouse down and mouse up) supported for all terminal types
    * Mouse wheel supported for all but the X10 protocol: You can scroll the 
      panels in midnight commander with the mouse wheel!
    * New command: `set mouse reporting x` where x is one of:
        * `disabled` - mouse events will not be reported
        * `enabled` - Applications can turn mouse reporting on. Mouse reports 
          will be sent only if a mouse event is mapped to `\Kignore` (eg, if you 
          map right-click to `\Kpaste` then right-click will never be sent)
        * `override` - Applications can turn mouse reporting on. All mouse  
          events will be sent to the remote host and any configured action in 
          CKW will be ignored when mouse reporting is on. For example, if you
          map right-click to `\Kpaste` this will only have an effect outside of
          applications that turn mouse reporting on.
    * The `show mouse` command shows the mouse reporting setting plus current
      state (if it's active or not, and the protocol in use)
* The old registry tool (`k95regtl.exe`) is back and fixed up for C-Kermit as an
  interim solution until a proper installer is created. This tool lets you 
  create desktop & start menu shortcuts and the .ksc file association.
* The dialer is now included by default with C-Kermit for Windows as changes to
  the SSH options render it incompatible with Kermit 95 (and the Kermit 95
  version incompatible with CKW)
* DECnet support has been re-enabled. You must install a licensed copy of
  Pathworks32 in order to make LAT or CTERM connections.
* SuperLAT support is now available as a custom build option - it is not enabled
  by default due to the unclear license on the publicly available Meridian
  SuperLAT SDK.
* The Telnet Encryption Option (DES/CAST) is supported again, not that you
  should use it if you care about security.

### Fixed Bugs
* Fixed a bug introduced in beta 3 that can prevent the cursor and other 
  elements on the screen with the blink attribute set from blinking reliably
* File transfers over SSH are now _much_ faster
* Fixed the `set mouse activate` command (aka `set terminal mouse`) in K95G -
  previously this command only worked in the old console version.
* Fixed support for the third mouse button in K95G - previously this only worked
  in the old console version. This change may affect your mouse button mapping!
* Fixed a mark being set (and not cleared on mouse button release) on drag when
  the drag event is mapped to `\Kignore`
* Fixed decoding of mouse scroll wheel event coordinates
* The context (right-click) menu in the dialer now works again
* The manual command now works
* The `show mouse` command no longer tries to output non-printable characters 
  bound to mouse events
* SSH will now prompt for a username if the default login userid has been 
  cleared (this is how Kermit 95 behaved)
* Fixed SSH help error: hmac-md5 is not supported, but hmac-sha1 is
* The GUI window now resizes correctly on Windows NT 3.5x

### Minor Enhancements and other changes:
* Upgraded to zlib 1.2.13 fixing [CVE-2022-37434](https://nvd.nist.gov/vuln/detail/CVE-2022-37434)
* Upgraded to openssl 1.1.1s
* The libssh version number is now included in the output of the `show ssh`
  command
* The default k95custom.ini now sets the default browser to nothing which should
  result in Edge being used instead of Internet Explorer. This is just a 
  temporary workaround for the default browser not being correctly picked up.
* Dialer: removed SSH v1 options as CKW now supports SSH 2.0 exclusively
* Dialer: Updated the lists of available ciphers, macs and host key algorithms 
  to match what CKW actually supports

### Source Changes:
* The Dialer now builds with OpenWatcom 1.9 and Visual C++ 2.0
* dropped the /ALIGN linker flag which has produced a linker warning since 
  Visual C++ 5.0 SP3 (November 1997)

## C-Kermit for Windows 10.0b4 beta 3 - 14 September 2022
This release focused on improving SSH support, returning SSL support, minor
enhancements, porting to new platforms (NT 3.50, OS/2) and new compilers
(Visual C++ 2.0, OpenWatcom 2.0, OpenWatcom 1.9 for OS/2)

### New Features:
* Idle SSH sessions can now be prevented from timing out by supplying some
  interval to the "set ssh heartbeat" command, for example: set ssh heartbeat 60
* Added support for "user@host" syntax to SSH command. "ssh root@myhost" should
  do the same as "ssh myhost /user:root" now. The implementation is pretty basic
  and may not handle weird input well but when it works it should be less
  confusing to new users.
* Added mouse wheel support. By default, it scrolls one line at a time, or one
  screen at a time when holding Ctrl. You can remap this to whatever you like
  via the new "set mouse wheel" command which works like "set mouse button".
* File save dialogs are now the modern (normal) type on Windows ME, 2000 and
  newer. Windows 95, 98 and NT4 retain the old Windows 95-look file dialogs as
  before.
* The Shell Execute utility, se.exe, is back. Documentation is here:
  https://kermitproject.org/k95manual/url.html#urlsexe
* SSL and TLS support has returned. The http command can now make https
  connections, secure telnet (telnet-ssl) works again, as does ftps
* SSH is now supported on Windows XP (for now - it will probably disappear in a
  year or so when OpenSSL drops XP support)
* The screen update interval is no longer fixed at 100ms - you can now change it
  with the "set terminal screen-update fast" command. Smaller intervals will
  feel smoother. If the interval is too small for your computer elements that
  are supposed to blink (such as the cursor if noblink is not set) may not
  blink or may not blink consistently.
* The /subsystem qualifier now works on the SSH command, as does the "skermit"
  command allowing you to use kermit as an SSH subsytem. Documentation:
  https://kermitproject.org/skermit.html
* SSH Keyboard Interactive authentication is now supported
* New SSH-related command: set ssh v2 key-exchange-methods
* "set tcp nodelay" should affect SSH sessions now too
* Implemented these SSH-related commands:
    * set ssh v2 ciphers
    * set ssh v2 hostkey-algorithms. New options: ecdsa-sha2-nistp256,
      ecdsa-sha2-nistp384, ecdsa-sha2-nistp521, rsa-sha2-256, rsa-sha2-512,
      ssh-ed25519
    * set ssh v2 macs. New options: hmac-sha1-etm@openssh.com, hmac-sha2-256,
      hmac-sha2-256-etm@openssh.com, hmac-sha2-512,
      hmac-sha2-512-etm@openssh.com, none
    * set ssh heartbeat-interval
    * ssh key create
    * ssh key display
    * ssh key change-passphrase

### Fixed Bugs:
* Fixed bug where some applications (eg, nano, htop) wouldn't come back properly
  after being suspended with Ctrl+Z and restored with `fg` when using the linux
  terminal type.
* Fixed terminal being cleared the first time you move the K95G window and
  possibly the other random occurrences of this happening
* Fixed terminal scrolling bug in OpenWatcom! Builds done with OpenWatcom are
  now functionally equivalent to Visual C++ 6 in platform support and features
  and have no known issues unique to that compiler.
* Fixed auto-download "ask" setting not working on Windows NT 3.51
* Receiving large files (>4GB) no longer fails with "Refused, size"
* Fixed the "space" command never reporting more than 4GB of available free
  space
* Fixed incorrect (too narrow) window size on first run

### Minor Enhancements and other changes:
* Improved error message when no authentication methods supported by the SSH
  server are enabled
* Upgraded to libssh 0.10.3
* Adjusted how the cursor is drawn so it blinks more nicely in the GUI version
  of CKW
* Removed these SSH commands as they are obsolete and will never be supported by
  libssh, the SSH backend used by CKW:
    * set ssh v1
    * set ssh version 1
    * set ssh v2 authentication {external-keyex, hostbased, srp-gex-sha1}
    * set ssh v2 ciphers {arcfour, blowfish-cbc, cast128-cbc, rijndael128-cbc,
      rijndael192-cbc, rijndael256-cbc}
    * set ssh v2 macs {hmac-md5, hmac-md5-96, hmac-ripemd160, hmac-sha1-96}
    * set ssh {kerberos4, kerberos5, krb4, kerb5, k4, k5}
    * ssh key v1
    * ssh key display /format:ietf
    * ssh v2 rekey

### Source Changes:
* Fixed compatibility with the OpenWatcom 2.0 fork
* Added support for building with Visual C++ 2.0
* Added support for targeting Windows NT 3.50 with either OpenWatcom 1.9 or
  Visual C++ 2.0
* Now builds on OS/2 with OpenWatcom 1.9. Only minimal testing has been done.
  Networking does not work and the builds are done without optimisations.
  Further work is required, likely by someone with OS/2 development knowledge,
  to get it back to the Kermit-95 level of functionality.
* OpenSSL 0.9.8 - 3.0.5 (the latest version) now works
* Added support for TLS 1.1, 1.2 and 1.3 when built with sufficiently new
  versions of OpenSSL


## C-Kermit for Windows 10.0b4 beta 2 - 17 August 2022
This release focused on returning some level of SSH support. Initial efforts 
were based on using an external SSH implementation which resulted in fixes to 
the DLL, PTY and COMMAND network types. External SSH didn't work well enough in 
the end so focus shifted to built-in SSH using libssh.

Support for some older Visual C++ releases (4.0 and 5.0) was added to enable 
RISC NT builds in the future (Visual C++ 4.0 was the last release to support 
MIPS and PowerPC), and OpenWatcom 1.9 support was added to enable future OS/2 
work.

 * Fixed builds with Visual C++ 14.x (2015-2022)
 * Fixed file transfer crash on builds done with Visual C++ 2008 and newer
 * Fixed builds with free versions of Visual C++ that don't include MFC
 * PTY support on Windows 10 v1809 and newer
 * Added OpenWatcom 1.9 support (win32 target only)
 * Fixed building with Visual C++ 97 (5.0)
 * Fixed building with Visual C++ 4.0
 * Fixed building with the free Visual C++ 2003 toolkit & Platform SDK
 * Fixed 64bit file seeking
 * Fixed detection of current windows releases
 * Fixed network DLL support (set network type dll)
 * Fixed file transfers when built with Visual C++ 5.0 and older
 * Removed ctl3dins.exe from the distribution (Windows defender thinks its 
   malware)
 * Now uses modern windows UI widgets on XP and newer
 * Built-in SSH
 * Added support for resizing DLL and PTY terminals when the CKW terminal is 
   resized

## C-Kermit for Windows 10.0b4 beta 1 - 17 July 2022
This release focused on tidying up the open-source Kermit 95 release of 
July 2011, getting it into a buildable state, and rebranding it as C-Kermit for 
Windows. No effort was made to replace features missing from the original open 
source release except for the GUI code (which was recovered and open-sourced in 
late 2013).

It was based on C-Kermit 10.0 beta.04 and is best built with Visual C++ 6 though
7.0-8.0 (2002, 2003, 2005) do work too.

 * Upgraded from C-Kermit 8.0.207 to C-Kermit 10.0 beta.04. See the 
   [C-Kermit 8.0.208 to 10.0b4 Change Log](https://www.kermitproject.org/ckupdates.html#ck100beta04)
   for more information on all that's changed there.
 * SRP support disabled
 * DECnet support disabled
 * LAT support disabled
 * Kerberos support disabled
 * SSH support removed
 * SSL support disabled
 * Other encryption features disabled
 * X/Y/Z modem support removed
 * OS/2 support disabled
 * Dialer removed
 * zlib support disabled
 * Fixed builds with Visual C++ 6
 * Fixed builds with Visual C++ 7
 * Removed 64bit file seeking - code was broken.
 * Removed licensing, registration and demo mode functionality
 * Reworked the About dialog
 * Fixed builds with Visual C++ 8 (2005)
 * Fixed builds with Visual C++ 7.1 (2003)
 * Fixed builds with Visual C++ 2010 and 2012
 * Updated version number, copyright dates, icons
 * Changed application name from Kermit 95 to C-Kermit for Windows
 * Disabled DNS SRV support
 * Removed border from GUI dialog buttons
 * Unused KUI code deleted
 * Fixed the pipe command
 * Fixed URLs in the help menu
 * Dropped separate version number for C-Kermit on Windows
 * Updated Windows version check
 * Replaced "K95" with "CKW" in the status line and prompt

## Kermit 95 v2.2 - never publicly released
Kermit 95 v2.2 was never publicly released, but 
[this file](https://www.kermitproject.org/k95-fixes-since-213.txt) documents 
what's new since Kermit 95 v2.1.3.

Not every change for K95 v2.2 has made it in to C-Kermit for Windows due to the 
removal of some components that could not be open-sourced. In particular,
changes for the Dialer in K95 v2.2 do not apply as the CKW dialer is based on
K95 v2.1.3, and changes for the SSH subsystem don't apply to CKW as CKW uses an
entirely new SSH implementation.

## Previous Kermit 95 releases
 * [1.1.21 to 2.1.3 Change Log](http://www.columbia.edu/kermit/k95news.html)
 * [1.1.17 to 1.1.20 Change Log](https://web.archive.org/web/20010405154138/http://www.columbia.edu/kermit/k95news.html)
 * [1.1.16 Changes](https://groups.google.com/g/comp.protocols.kermit.announce/c/8jaYcOv0cvo/m/Er5rCyp_xG8J)
 * [1.1.15 Changes](https://groups.google.com/g/comp.os.ms-windows.announce/c/IDbj1Dl16aU/m/WmJlmGtSY5cJ)
 * [1.1.14 Changes](https://groups.google.com/g/comp.protocols.kermit.announce/c/KWT_5sYXeC8/m/AGvXUCtXSh4J)
 * [1.1.2 to 1.1.13 Change Log](https://web.archive.org/web/19970815161519/http://www.columbia.edu/kermit/k95news.html)
 * 1.1.1 Changes - ?