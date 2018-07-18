if not defined QLIC_KC (
 goto :nokdb
)
echo|set /P =%QLIC_KC% >kc.lic.enc
certutil -decode kc.lic.enc kc.lic
set QLIC=%CD%
echo 0N!`qruns | q
q test.q -q 
echo done
exit /b 0

:error
exit %errorLevel%

:nokdb
echo no kdb
exit /b 0
