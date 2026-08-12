# Installs/configures add ons for the EKS cluster
resource "aws_eks_addon" "vpc_cni" {
  # while we're upgrading we don't want these to be created until we're on 1.20 cluster
  count             = var.create_eks && var.enable_vpc_cni_addon ? 1 : 0
  cluster_name      = aws_eks_cluster.this[0].name
  addon_name        = "vpc-cni"
  addon_version     = var.vpc_cni_version
  resolve_conflicts = var.vpc_cni_resolve_conflicts
}

resource "aws_eks_addon" "coredns" {
  count             = var.create_eks && var.enable_coredns_addon ? 1 : 0
  cluster_name      = aws_eks_cluster.this[0].name
  addon_name        = "coredns"
  addon_version     = var.coredns_version
  resolve_conflicts = var.coredns_resolve_conflicts
  configuration_values = jsonencode({
    autoScaling = {
      enabled = var.coredns_scaling_enabled
      minReplicas = var.coredns_minreplicas
      maxReplicas = var.coredns_maxreplicas
    }
    corefile = <<-EOT
    .:53 {
      errors
      health {
        lameduck 30s
      }
      ready
      kubernetes cluster.local in-addr.arpa ip6.arpa {
        pods insecure
        fallthrough in-addr.arpa ip6.arpa
      }
      prometheus :9153
      forward . /etc/resolv.conf
      cache 30 3600 10
      loop
      reload
      loadbalance
    }
EOT
  })
}

resource "aws_eks_addon" "kube_proxy" {
  count             = var.create_eks && var.enable_kube_proxy_addon ? 1 : 0
  cluster_name      = aws_eks_cluster.this[0].name
  addon_name        = "kube-proxy"
  addon_version     = var.kube_proxy_version
  resolve_conflicts = var.kube_proxy_resolve_conflicts
}

resource "aws_eks_addon" "aws_ebs_csi_driver" {
  count                    = var.create_eks && var.enable_aws_ebs_csi_driver_addon ? 1 : 0
  cluster_name             = aws_eks_cluster.this[0].name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = var.aws_ebs_csi_driver_version
  resolve_conflicts        = var.aws_ebs_csi_driver_resolve_conflicts
  service_account_role_arn = var.ebs_csi_driver_role_arn
}

# EKS EFS CSI ADD-ON Module
resource "aws_eks_addon" "aws_efs_csi_driver" {
  count                    = var.create_eks && var.enable_aws_efs_csi_driver_addon ? 1 : 0
  cluster_name             = aws_eks_cluster.this[0].name
  addon_name               = "aws-efs-csi-driver"
  addon_version            = var.aws_efs_csi_driver_version
  resolve_conflicts        = var.aws_efs_csi_driver_resolve_conflicts
  service_account_role_arn = var.efs_csi_driver_role_arn
}

# EKS FSx CSI ADD-ON Module
resource "aws_eks_addon" "aws_fsx_csi_driver" {
  count                       = var.create_eks && var.enable_aws_fsx_csi_driver_addon ? 1 : 0
  cluster_name                = aws_eks_cluster.this[0].name
  addon_name                  = "aws-fsx-csi-driver"
  addon_version               = var.aws_fsx_csi_driver_version
  resolve_conflicts_on_update = var.aws_fsx_csi_driver_resolve_conflicts
  service_account_role_arn    = module.fsx_csi_irsa[0].iam_role_arn

  # Optional JSON-encoded add-on configuration (e.g. node.nodeSelector / node.tolerations /
  # resources) so the fsx-csi-node DaemonSet can be restricted to nodes that actually mount
  # FSx instead of running on every node. Null when unset to preserve prior behavior.
  configuration_values = var.aws_fsx_csi_driver_configuration_values != "" ? var.aws_fsx_csi_driver_configuration_values : null

  tags = var.tags
}

# Optional configuration values for the aws-fsx-csi-driver add-on.
# Declared here (rather than variables.tf) to keep this feature self-contained.
variable "aws_fsx_csi_driver_configuration_values" {
  description = "JSON-encoded configuration values passed to the aws-fsx-csi-driver EKS add-on. Common use: restrict the fsx-csi-node DaemonSet via node.nodeSelector / node.tolerations. Leave empty to omit configuration_values entirely."
  type        = string
  default     = ""
}
