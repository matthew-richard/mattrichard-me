
# AWS shortuts

aws-ec2-get-instance-by-name () {
  aws ec2 describe-instances --output text \
    --filters Name=tag:Name,Values="$1" \
    --query 'Reservations[*].Instances[*].[InstanceId]'
}

aws-ec2-start-instance-by-name () {
  aws ec2 start-instances --instance-ids `aws-ec2-get-instance-by-name $1`
}

aws-ec2-stop-instance-by-name () {
  aws ec2 stop-instances --instance-ids `aws-ec2-get-instance-by-name $1`
}

website-ec2-start () {
  aws-ec2-start-instance-by-name $WEBSITE_AWS_INSTANCE_NAME
}

website-ec2-stop () {

}

website-ec2-status () {

}

# Save bash history immediately
export PROMPT_COMMAND="history -a"
shopt -s histappend

# Set large bash_history history size
HISTSIZE=20000
HISTFILESIZE=20000

# Hide ugly green backgrounds on NTFS folders (when running in a Windows host)
LS_COLORS="ow=01;36;40" && export LS_COLORS
