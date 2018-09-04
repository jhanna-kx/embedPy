if not defined QLIC (
 goto :nokdb
)
call q conda-recipe/prep_requirements.q -q <nul
conda install -y -q --file tests\requirements_filtered.txt
call q test.q -s 4 -q <nul || goto :error
exit /b 0

:error
exit /b %errorLevel%

:nokdb
echo no kdb
exit /b 0
