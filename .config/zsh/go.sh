export GOPATH=$DATA_HOME/go

[[ ${PATH#*$GOPATH/bin} == "$PATH" ]] && export PATH=$PATH:$GOPATH/bin

# many thanks to the Great Firewall
export GOPROXY='https://goproxy.cn'
