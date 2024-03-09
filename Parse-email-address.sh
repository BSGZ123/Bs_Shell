#!/usr/bin/env bash
# sudo echo "rich@here.now" | sudo ./test3.sh
# sudo echo "rich@here.now."  | sudo ./test3.sh
gawk '/^([a-zA-Z0-9_\-\.\+]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})/{print $0}'

