export GOPATH=~/go

[[ ${PATH#*$GOPATH/bin} == $PATH ]] && export PATH=$GOPATH/bin:$PATH
