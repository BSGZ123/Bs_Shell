#!/usr/bin/env bash
today=$(date +%y%m%d)
# 设置备份文件名
backupFile=archive$today.tar.gz

# 设置配置和目标文件
config_file=/archive/Files_To_Backup.txt #记录要备份的多个目录
destination=/archive/$backupFile  #备份文件的完整目录

##########主要脚本################
if [ -f $config_file ] #判断备份配置文件是否存在
then
  echo
else
  echo
  echo "$config_file 文件不存在。"
  echo "备份进程中止，因为没有可用的配置文件"
  echo
  exit
fi

#
# 处理要备份的文件名称
#
file_no=1 #从配置文件的第一行开始
exec 0< $config_file #将配置文件重定向至STDOUT中输入

read file_name

while [ $? -eq 0 ] #检查read 返回的结果是否为0 读取至末尾为非0 退出循环
do
  if [ -f $file_name -o -d $file_name ]
  then
   # 如果文件存在，则加入到文件列表中
   file_list="$file_list $file_name"
  else

   echo
   echo "$file_name, 文件不存在"
   echo "这在配置文件的 $file_no 行出现问题"
   echo "继续备份中..."
   echo
  fi
  file_no=$[$file_no + 1]
  read file_name # 读取下一条备份记录
done

# 判断file_list是否为空
if [ -z "$file_list" ];
then
    echo "没有需要备份的文件记录，脚本正常退出"
    exit
else
    echo ""
fi

####开始备份操作#####
echo "开始备份..."
sleep 3
echo
#
tar -czf $destination $file_list 2> /dev/null
#
echo "备份完成！"
echo " 备份文件已保存至: $destination"
echo
# 正常退出
exit
