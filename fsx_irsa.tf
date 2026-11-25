# FSx CSI Driver IAM Role for Service Account (IRSA)
module "fsx_csi_irsa" {
  source = "./modules/iam-service-account"

  count = var.create_eks && var.enable_aws_fsx_csi_driver_addon ? 1 : 0

  role_name        = "fsx-csi-driver-${var.cluster_name}"
  role_description = "IAM role for FSx CSI driver"
  provider_url     = replace(aws_eks_cluster.this[0].identity[0].oidc[0].issuer, "https://", "")
  # NB: pinned snapshot of AmazonFSxFullAccess; reading the managed policy live drifts whenever AWS edits it.
  role_policy_document          = file("${path.module}/policies/fsx-csi-driver.json")
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:fsx-csi-controller-sa"]

  tags = var.tags
}
