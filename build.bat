@echo off

pushd build

set COMMON_FLAGS=/Od /W1 /Z7 /EHsc /wd4996 /nologo /MD
set BUILD_FLAGS=%COMMON_FLAGS% /I../src /I../inc

set SRC_FILES=..\src\symcipher\*.c ..\src\codec\*.c ..\src\int\*.c ..\src\ec\*.c ..\src\ssl\*.c ..\src\mac\*.c ..\src\aead\*.c ..\src\rsa\*.c ..\src\hash\*.c ..\src\rand\*.c ..\src\x509\*.c ..\src\kdf\*.c ..\tools\*.c

REM build bearssl.lib
mkdir objs
cl /c %SRC_FILES% /Foobjs\ %BUILD_FLAGS% 
lib /nologo /out:bearssl.lib objs\*.obj

REM build brssl.exe
cl ../tools/brssl.c ../src/settings.c /Febrssl.exe %BUILD_FLAGS% /link bearssl.lib

REM build samples/client_basic_win32.c
set SAMPLE_BUILD_FLAGS=%BUILD_FLAGS% /link Ws2_32.lib bearssl.lib
cl ../samples/client_basic_win32.c /Feclient_basic.exe %SAMPLE_BUILD_FLAGS% 

cl ../test/test_x509.c /Fetest_x509.exe %BUILD_FLAGS% /link bearssl.lib
cl ../test/test_speed.c /Fetest_speed.exe %BUILD_FLAGS% /link bearssl.lib
cl ../test/test_crypto.c /Fetest_crypto.exe %BUILD_FLAGS% /link bearssl.lib
REM cl ../test/test_math.c /Fetest_math.exe %BUILD_FLAGS% /link bearssl.lib

del *.ilk
del *.obj

popd