move p.q, p.k %QHOME% || goto :error
move w64/p.so %QHOME%/w64 || goto :error
exit 0
:error
exit /b %errorlevel%

