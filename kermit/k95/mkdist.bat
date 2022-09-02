@echo off
@echo === Make Distribution ===

@echo Create directories...
if not exist dist\NUL mkdir dist
if not exist dist\docs\NUL mkdir dist\docs
if not exist dist\docs\manual\NUL mkdir dist\docs\manual

@echo Move build outputs...
move *.exe dist
copy *.manifest dist
ren dist\cknker.exe k95.exe
ren dist\cknker.exe.manifest k95.exe.manifest
del dist\cknker.exe.manifest
del dist\ctl3dins.exe
move dist\ckwart.exe .\

@echo Copy manual...
copy ..\..\doc\manual\ckwin.htm dist\docs\manual\
if exist dist\ssh.dll copy ..\..\doc\ssh-readme.md dist\ssh-readme.txt

@echo Copy resources...
copy k95.ini dist
copy k95custom.ini dist
copy k95d.cfg dist

@echo Copy runtime libraries
if defined WATCOM copy %WATCOM%\binnt\mt7r*.dll dist
if defined WATCOM copy %WATCOM%\binnt\clbr*.dll dist
if defined WATCOM copy %WATCOM%\binnt\plbr*.dll dist

@echo Copy enabled optional dependencies
for %%I in (%CK_DIST_DLLS%) do copy %%I dist\
