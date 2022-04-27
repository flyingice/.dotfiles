export GOPATH=$HOME/go

[[ ${PATH#*$GOPATH/bin} == $PATH ]] && export PATH=$PATH:$GOPATH/bin
