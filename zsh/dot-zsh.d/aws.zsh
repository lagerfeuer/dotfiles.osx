function mfa {
  op item get "AWS NBauth" --otp
}

function ar {
  awsume --mfa "$(mfa)" $@
}

alias unar="awsume --unset"

alias aws-get-id='aws sts get-caller-identity | jq .'
alias aws-whoami='aws sts get-caller-identity | jq .'

