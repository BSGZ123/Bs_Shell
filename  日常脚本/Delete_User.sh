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

# 创建该用户账户所拥有的全部文件的报告
# 删除该用户账户
