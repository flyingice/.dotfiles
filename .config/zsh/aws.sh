# https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-completion.html
# enable aws-cli command completion
autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit
complete -C "$(command -v aws_completer)" aws

# https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html
# https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html#cli-configure-quickstart-precedence
# configuration settings in environment variables take precedence over those in config files

# https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html#using-profiles
# export AWS_PROFILE=
