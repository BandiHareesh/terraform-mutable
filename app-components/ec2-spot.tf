resource "aws_spot_instance_request" "instances" {
  count                         = var.SPOT_INSTANCE_COUNT
  ami                           = data.aws_ami.ami.id
  instance_type                 = var.INSTANCE_TYPE
  vpc_security_group_ids        = [aws_security_group.allow_component.id]
  wait_for_fulfillment          = true
  subnet_id                     = element(data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS,count.index)
  tags                          = {
    Name                        = "${var.COMPONENT}-${var.ENV}-spot"
  }
}

resource "aws_ec2_tag" "name-tag" {
  count                         = var.SPOT_INSTANCE_COUNT
  resource_id                   = element(aws_spot_instance_request.instances.*.spot_instance_id,count.index)
  key                           = "Name"
  value                         = "${var.COMPONENT}-${var.ENV}-spot"
}

resource "aws_ec2_tag" "monitor-tag" {
  count                         = var.SPOT_INSTANCE_COUNT
  resource_id                   = element(aws_spot_instance_request.instances.*.spot_instance_id,count.index)
  key                           = "Monitor"
  value                         = "yes"
}
