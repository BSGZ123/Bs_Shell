#!/usr/bin/env bash

# 初始化变量

runAccountAudit="false"
runPermAudit="false"

reportDir="/home/christine/scripts/AuditReports"

while getopts :Ap opt
do
case "$opt" in
A) runAccountAudit="true" ;;
p) runPermAudit="true" ;;
*) echo "不是有效的功能参数"
echo "有效参数有: -A, -p, or -Ap"
exit
;;
esac
done

if [ $OPTIND -eq 1 ]
then
# 没有提供任何选项； 将所有设置为“true”
runAccountAudit="true"
runPermAudit="true"
fi




