locals {
  worker_policy_list = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}

resource "aws_iam_role_policy_attachment" "karpenter_policy_attachments" {
  count      = var.manage_worker_iam_resources && var.create_eks ? length(local.worker_policy_list) : 0
  policy_arn = local.worker_policy_list[count.index]
  role       = aws_iam_role.karpenter_role[0].name
}

# Karpenter requires a node instance profile created to be passed to the helmfile
resource "aws_iam_role" "karpenter_role" {
  count                 = var.manage_worker_iam_resources && var.create_eks ? 1 : 0
  name                  = "karpenter_node_role_${var.logging_stage}"
  permissions_boundary  = var.permissions_boundary
  path                  = var.iam_path
  force_detach_policies = true
  tags                  = var.tags
  assume_role_policy    = data.aws_iam_policy_document.workers_assume_role_policy.json
}

resource "aws_iam_instance_profile" "karpenter_node_instance_profile" {
  name = "karpenter_node_instance_profile_${var.logging_stage}"
  role = aws_iam_role.karpenter_role[0].name
}

data "aws_kms_alias" "ebs" {
  name = "alias/aws/ebs"
}
resource "aws_iam_policy" "kms_key_policy" {
  name        = "${var.logging_stage}-kms-key-policy"
  description = "Policy for kms key used by EBS volumes"


  policy = jsonencode({
    Version : "2012-10-17"
    Statement : [
      {
        "Action" : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        "Effect" : "Allow",
        "Resource" : data.aws_kms_alias.ebs.arn,
        "Sid" : "KmsKey"
      },
      {
        Action = [
          "route53:ListHostedZones",
          "route53:ChangeResourceRecordSets",
          "route53:ListResourceRecordSets"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "ec2:DescribeLaunchTemplateVersions",
          "autoscaling:DescribeTags",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeAutoScalingGroups"
        ]
        Effect   = "Allow"
        Resource = "*"
        Sid      = "eksWorkerAutoscalingAll"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "kms_key_role_policy_attachment" {
  role       = aws_iam_role.karpenter_role[0].name
  policy_arn = aws_iam_policy.kms_key_policy.arn
}
