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

if [ $runAccountAudit = "true" ]
then
 echo
 echo "****** 账户审计 *****"
 echo
 echo "当前 false/nologin shell 数量： "
 reportDate="$(date +%F%s)"
 accountReport=$reportDir/AccountAudit$reportDate.rpt
 cat /etc/passwd | cut -d: -f7 |
 grep -E "(nologin|false)" | wc -l |
 tee $accountReport
 sudo chattr +i $accountReport
 prevReport="$(ls -1t $reportDir/AccountAudit*.rpt |
 sed -n '2p')"

 if [ -z $prevReport ]
 then
  echo
  echo "没有以前的错误/未登录报告可供比较。"
 else
  echo
  echo "之前报告的 false/nologin shell： "
  cat $prevReport
 fi
fi


## Permissions Audit ##############
if [ $runPermAudit = "true" ]
then
echo
echo "****** SUID/SGID Audit *****"
echo
reportDate="$(date +%F%s)"
permReport=$reportDir/PermissionAudit$reportDate.rpt
#
# Create current report
echo "Creating report. This may take a while..."
sudo find / -perm /6000 >$permReport 2>/dev/null
#
# Change report's attributes:
sudo chattr +i $permReport
#
# Compare to last permission report
#
#
prevReport="$(ls -1t $reportDir/PermissionAudit*.rpt |
sed -n '2p')"
#
if [ -z $prevReport ]
then
 echo
 echo "No previous permission report exists to compare."
else
 echo
 echo "Differences between this report and the last: "
#
 differences=$(diff $permReport $prevReport)
 if [ -z "$differences" ]
 then
  echo "No differences exist."
  else
 echo $differences
  fi
 fi
fi

exit

