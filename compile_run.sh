#!/bin/bash

export VCS_HOME=/auto/da/cad/synopsys/VCS/vcs_mx_vE-2011.03-SP1 #путь к папке с VCS
export BF_HOME=/home/kozlov_m/RTL/BUFFER    #путь к папке с буфером
 
$VCS_HOME/bin/vlogan +nospecify +notimingchecks +define+USING_VCS +v2k -f ${BF_HOME}/vlog.opt   #компиляция с указанными параметрами
$VCS_HOME/bin/vcs -debug -l elab.log +nospecify +notimingchecks buffer_tb   #запуск моделирования на VCS
$VCS_HOME/bin/dve -toolexe simv #запуск времянки в DVE
