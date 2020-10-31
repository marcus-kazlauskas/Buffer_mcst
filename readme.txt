Здесь представлено verilog-описание аппаратного буфера с записью в ячейку данных и адреса по её номеру, чтением данных из неё по входящему адресу чтения и освобождением ячейки по указанному номеру.

export VCS_HOME=/auto/da/cad/synopsys/VCS/vcs_mx_vE-2011.03-SP1 //(на этой версии VCS производилось тестирование)
export BF_HOME=/home/kozlov_m/RTL/BUFFER //(путь к папке с верилогом)
 
$VCS_HOME/bin/vlogan +nospecify +notimingchecks +define+USING_VCS +define+TRACING_ON=1 +v2k -f ${BF_HOME}/vlog.opt  //компиляция с указанными параметрами
$VCS_HOME/bin/vcs -debug -l elab.log +nospecify +notimingchecks buffer_tb //запуск моделирования на VCS
$VCS_HOME/bin/dve dump.vpd  //запуск времянки в DVE
