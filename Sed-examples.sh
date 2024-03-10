# 加倍行间距
sed '$!G' data2.txt

# 对可能含有空行的文件加倍行间距 先删除已有的空行，再重新添加
sed '/^$/d ; $!G' data3.txt

# 给文件中的行编号 获得等号命令的输出，通过管道传输给另一sed，用于合并两行，同时将换行符替换位空格
sed '=' data2.txt | sed 'N; s/\n/ /'

# 打印末尾行
sed -n '$p' data2.txt

# 删除连续的空行
sed '/./,/^$/!d' data8.txt

# 删除开头的空行
sed '/./,$!d' data9.txt

# 删除结尾的空行 采用shell包装器
sed '{
:start
/^\n*$/{$d; N; b start }
}'

# 删除HTML标签
sed 's/<[^>]*>//g' index.html
