export NVM_DIR=$DATA_HOME/nvm

if [[ "$OSTYPE" == "darwin"* ]]; then
  # load nvm
  [[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]] && source "/opt/homebrew/opt/nvm/nvm.sh"
  # load nvm bash_completion
  [[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ]] && source "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
else
  [[ -s "$NVM_DIR"/nvm.sh ]] && source "$NVM_DIR"/nvm.sh
  [[ -s "$NVM_DIR"/bash_completion ]] && source "$NVM_DIR"/bash_completion
fi
