resource "aws_eks_node_group" "workers" {
  depends_on = [local.ng_dependency]
  for_each = local.node_groups_expanded

  node_group_name = each.value["name"]
  version         = lookup(each.value, "version", null)
  capacity_type   = each.value["capacity_type"] # SPOT or ON_DEMAND

  cluster_name  = var.cluster_name
  node_role_arn = each.value["iam_role_arn"]
  subnet_ids    = each.value["subnets"]

  scaling_config {
    desired_size = each.value["desired_capacity"]
    max_size     = each.value["max_capacity"]
    min_size     = each.value["min_capacity"]
  }

  disk_size       = var.node_groups_defaults["disk_size"]
  instance_types  = each.value["instance_types"]

  # These shouldn't be needed as we specify the version
  ami_type        = lookup(each.value, "ami_type", null)
  release_version = lookup(each.value, "ami_release_version", null)

  dynamic "remote_access" {
    for_each = each.value["key_name"] != "" ? [{
      ec2_ssh_key               = each.value["key_name"]
      source_security_group_ids = lookup(each.value, "source_security_group_ids", [])
    }] : []

    content {
      ec2_ssh_key               = remote_access.value["ec2_ssh_key"]
      source_security_group_ids = remote_access.value["source_security_group_ids"]
    }
  }

  dynamic "launch_template" {
    for_each = each.value["launch_template_id"] != null ? [{
      id      = each.value["launch_template_id"]
      version = each.value["launch_template_version"]
    }] : []

    content {
      id      = launch_template.value["id"]
      version = launch_template.value["version"]
    }
  }

  dynamic "launch_template" {
    for_each = each.value["launch_template_id"] == null && each.value["create_launch_template"] ? [{
      id      = aws_launch_template.workers[each.key].id
      version = each.value["launch_template_version"]
    }] : []

    content {
      id      = launch_template.value["id"]
      version = launch_template.value["version"]
    }
  }



  labels = merge(
    lookup(var.node_groups_defaults, "k8s_labels", {}),
    lookup(var.node_groups[each.key], "k8s_labels", {})
  )

  tags = merge(
    {
      Name = "${each.value["name"]}_node"
    },
    var.tags,
    lookup(var.node_groups_defaults, "additional_tags", {}),
    lookup(var.node_groups[each.key], "additional_tags", {}),
  )

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [scaling_config.0.desired_size]
  }

}
