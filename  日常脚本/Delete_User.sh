#!/usr/bin/env bash

# 获取并确认待删除的用户账户名
function get_answer {
  unset get_answer
  ask_count=0 #询问计数

  while [ -z "$answer" ] # -z测试answer是否为空
  do
    ask_count=$(( ask_count + 1 ))
    case $ask_count in
    2)
      echo
      echo "请回答被指定删除的用户名"
      echo
      ;;

    3)
      echo
      echo "最后一次机会了... 输入用户名"
      echo
      ;;

    4)
      echo
      echo "三次回答失败，退出脚本"
      echo
      exit
      ;;
    esac

    if [ -n "$line2" ] #判断变量中是否包含非空字符串
    then
      echo $line1
      echo -e $line2" \c"
    else
      echo -e $line1" \c"
    fi

    read -rt 60 answer #60秒超时

  done

  unset line1
  unset line2
}
#---------------------------------------------------
function  process_answer {
    #-c1 表示提取每行的第一个字符。
    answer=$(echo "$answer" | cut -c1) #引用变量可防止单词拆分和全局扩展，并在输入包含空格、换行符、全局字符等时防止脚本中断。
    case $answer in
    y|Y) #输入yes或Yes 读取第一个字符匹配，符合继续执行
      ;;
    *) # 输入其他字符则退出
      echo
      echo $exit_line1
      echo $exit_line2
      echo
      exit
      ;;
      esac

    unset exit_line1
    unset exit_line2

}
#-------------------主要脚本--------------------------
echo "第一步 - 确认要删除用户的账户名 "
echo
line1="请输入用户账户名 "
line2="您希望从系统中删除的帐户："
get_answer
user_account=$answer

# 二步检查确认
line1="该$user_account 是该用户的账户名吗？"
line2="确认删除吗？[y/n]"
get_answer

exit_line1="因为账户$user_account 错误 "
exit_line1="未选定删除目标，正在退出脚本"
process_answer

# 查找并中止待删除用户的运行进程
# 检查用户账户是否真实存在

user_account_record=$(cat /etc/passwd | grep -w $user_account)

if [ $? -eq 1 ]
then
  echo
  echo "该用户账户$user_account 不存在"
  echo
  exit
fi

echo
echo "脚本找到该用户记录:"
echo $user_account_record
echo

line1="请确认是否要删除该用户账户？[y/n]"
get_answer

exit_line1=" 用户确认 $user_account 不是删除目标"
exit_line2="您选择了不删除该用户账户，正在退出脚本"
process_answer

echo
echo "第二步 - 查找并中止待删除用户的运行进程"
echo

ps -u $user_account > /dev/null
case $? in
0)
  echo
  echo "该用户账户$user_account 正在运行"
  echo
  echo "该用户账户$user_account 正在运行的进程如下："
  echo
  ps -u $user_account
  echo

  line1="是否要中止该用户账户$user_account 的运行进程？[y/n]"
  get_answer
  answer=$(echo $answer | cut -c1)
  ;;
1)
  echo
  echo "该用户账户$user_account 没有进程在运行"
  echo

case $answer in
y|Y)
  echo
  echo "正在中止该用户账户$user_account 的运行进程"
  echo
  ps -u $user_account | awk '{print $2}' | xargs kill -9
  echo
  echo "该用户账户$user_account 的运行进程已中止"
  echo
  ;;
*)
  echo
  echo "该用户账户$user_account 的运行进程未中止"
  echo
  exit
  esac
  ;;
esac

# 创建该用户账户所拥有的全部文件的报告

echo
echo "第三步 - 查找本系统中被删除的用户账户所拥有的全部文件"
echo
echo "创建该用户账户 $user_account 所拥有的全部文件的报告 "
echo
echo "建议您在删除该用户账户之前，先将该用户账户所拥有的全部文件备份或移动到其他目录，"
echo "有两种选择"
echo " 1) 删除所有文件"
echo " 2) 改变文件所有着至当前操作用户"
echo
echo "请等待，正在操作中..."

report_date=$(date +%y%m%d)
report_file="$user_account"_Files_"$report_date".rpt
find / -user $user_account > $report_file 2>/dev/null

echo
echo "报告已生成"
echo "报告名称: $report_file"
echo -n "报告位置: "; pwd
echo

# 删除该用户账户
echo
echo "第四步 - 移除用户账户"
echo
#
line1="你确认要删除 $user_account ？ [y/n]"
get_answer

exit_line1="用户确认停止删除用户账号,"
exit_line2="$user_account 正在退出脚本..."
process_answer
#
userdel $user_account
echo
echo "用户账户, $user_account, 已被移除"
echo
#
exit
