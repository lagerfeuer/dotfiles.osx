function mfa {
  op item get "AWS NBauth" --otp
}

function ar {
  awsume --mfa "$(mfa)" $@
}

alias unar="awsume --unset"

alias aws-get-id='aws sts get-caller-identity | jq .'
alias aws-whoami='aws sts get-caller-identity | jq .'

function console-connect {
  if [[ -z "${1}" ]]; then
    echo "Usage: console-connect production|staging"
    return 1
  fi
  local -r env="${1}"
  local -r task_id="$(aws ecs list-tasks --cluster "${env}" --service-name nbuild-console | jq -r '.taskArns[0]' | rev | cut -d/ -f1 | rev)"
  aws ecs execute-command --cluster "${env}" --task "${task_id}" --container nbuild-console --interactive --command '/bin/sh'
}

