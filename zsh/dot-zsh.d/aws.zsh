function mfa {
  op item get "AWS NBauth" --otp
}

function aws-ar {
  local -r acc="${1}"
  if [[ -z "${acc}" ]]; then echo "Usage: ar prod|staging|central|jim"; fi
  acp "${acc}" "$(mfa)"
}

alias aws-unar="acp"

alias aws-get-id='aws sts get-caller-identity | jq .'
alias aws-whoami='aws sts get-caller-identity | jq .'

function console-connect {
  if [[ -z "${1}" ]]; then
    echo "Usage: console-connect production|staging"
    return 1
  fi

  local -r env="${1}"
  local -r service="${2:-nbuild-console}"
  local -r container="${3:-nbuild-console}"

  local -r task_id="$(aws ecs list-tasks --cluster "${env}" --service-name "${service}" | jq -r '.taskArns[0]' | rev | cut -d/ -f1 | rev)"
  aws ecs execute-command \
    --cluster "${env}" \
    --task "${task_id}" \
    --container "${container}" \
    --interactive \
    --command '/bin/sh'
}

