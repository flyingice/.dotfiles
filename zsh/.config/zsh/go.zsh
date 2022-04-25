export GOPATH=$HOME/go

[[ ${PATH#*"$GOPATH"/bin} == "$PATH" ]] && export PATH=$GOPATH/bin:$PATH
