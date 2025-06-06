variable "cluster_enabled_log_types" {
  default     = []
  description = "A list of the desired control plane logging to enable. For more information, see Amazon EKS Control Plane Logging documentation (https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html)"
  type        = list(string)
}
variable "cluster_log_kms_key_id" {
  default     = ""
  description = "If a KMS Key ARN is set, this key will be used to encrypt the corresponding log group. Please be sure that the KMS Key has an appropriate key policy (https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/encrypt-log-data-kms.html)"
  type        = string
}
variable "cluster_log_retention_in_days" {
  default     = 90
  description = "Number of days to retain log events. Default retention - 90 days."
  type        = number
}

variable "cluster_name" {
  description = "Name of the EKS cluster. Also used as a prefix in names of related resources."
  type        = string
}

variable "cluster_security_group_id" {
  description = "If provided, the EKS cluster will be attached to this security group. If not given, a security group will be created with necessary ingress/egress to work with the workers"
  type        = string
  default     = ""
}

variable "cluster_version" {
  description = "Kubernetes version to use for the EKS cluster."
  type        = string
  default     = "1.14"
}

variable "config_output_path" {
  description = "Where to save the Kubectl config file (if `write_kubeconfig = true`). Assumed to be a directory if the value ends with a forward slash `/`."
  type        = string
  default     = "./"
}

variable "write_kubeconfig" {
  description = "Whether to write a Kubectl config file containing the cluster configuration. Saved to `config_output_path`."
  type        = bool
  default     = true
}

variable "manage_aws_auth" {
  description = "Whether to apply the aws-auth configmap file."
  default     = true
}

variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap. See examples/basic/variables.tf for example format."
  type        = list(string)
  default     = []
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap. See examples/basic/variables.tf for example format."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap. See examples/basic/variables.tf for example format."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}

variable "subnets" {
  description = "A list of subnets to place the EKS cluster and workers within."
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "VPC where the cluster and workers will be deployed."
  type        = string
}

# Cluster addons vars
variable "enable_vpc_cni_addon" {
  description = "Whether or not to install the vpc-cni addon in the cluster"
  type        = bool
  default     = false
}

variable "vpc_cni_version" {
  description = "Version of the vpc-cni container to install"
  type        = string
}

variable "vpc_cni_resolve_conflicts" {
  description = "Whether or not to force overwrite of the config. Options: NONE, OVERWRITE"
  type        = string
  default     = "NONE"
}

variable "enable_coredns_addon" {
  description = "Whether or not to install the coredns addon in the cluster"
  type        = bool
  default     = false
}

variable "coredns_version" {
  description = "Version of the coredns container to install"
  type        = string
}

variable "coredns_resolve_conflicts" {
  description = "Whether or not to force overwrite of the config. Options: NONE, OVERWRITE"
  type        = string
  default     = "NONE"
}

variable "coredns_scaling_enabled" {
  description = "Whether or not to enable auto-scaling of coredns pods"
  type        = bool
  default     = false
}

variable "coredns_minreplicas" {
  description = "Minimum number of coredns pods (if autoscaling enabled)"
  type        = number
  default     = 2
}

variable "coredns_maxreplicas" {
  description = "Maximum number of coredns pods (if autoscaling enabled)"
  type        = number
  default     = 10
}

variable "enable_kube_proxy_addon" {
  description = "Whether or not to install the kube-proxy addon in the cluster"
  type        = bool
  default     = false
}

variable "kube_proxy_version" {
  description = "Version of the kube-proxy container to install"
  type        = string
}

variable "kube_proxy_resolve_conflicts" {
  description = "Whether or not to force overwrite of the config. Options: NONE, OVERWRITE"
  type        = string
  default     = "NONE"
}

variable "enable_aws_ebs_csi_driver_addon" {
  description = "Whether or not to install the ebs driver addon in the cluster"
  type        = bool
  default     = true
}

variable "aws_ebs_csi_driver_version" {
  description = "Version of the ebs csi driver container to install"
  type        = string
}

variable "aws_ebs_csi_driver_resolve_conflicts" {
  description = "Whether or not to force overwrite of the config. Options: NONE, OVERWRITE"
  type        = string
  default     = "NONE"
}

variable "ebs_csi_driver_role_arn" {
  description = "Role for ebs csi driver needed by the service accounts to perform ondemand volume resizing"
  type        = string
}

variable "worker_groups_launch_template" {
  description = "A list of maps defining worker group configurations to be defined using AWS Launch Templates. See workers_group_defaults for valid keys."
  type        = any
  default     = []
}

variable "worker_security_group_id" {
  description = "If provided, all workers will be attached to this security group. If not given, a security group will be created with necessary ingress/egress to work with the EKS cluster."
  type        = string
  default     = ""
}

variable "worker_ami_name_filter" {
  description = "Name filter for AWS EKS worker AMI. If not provided, the latest official AMI for the specified 'cluster_version' is used."
  type        = string
  default     = ""
}

variable "worker_ami_owner_id" {
  description = "The ID of the owner for the AMI to use for the AWS EKS workers. Valid values are an AWS account ID, 'self' (the current account), or an AWS owner alias (e.g. 'amazon', 'aws-marketplace', 'microsoft')."
  type        = string
  default     = "602401143452" // The ID of the owner of the official AWS EKS AMIs.
}

variable "worker_ami_owner_id_windows" {
  description = "The ID of the owner for the AMI to use for the AWS EKS Windows workers. Valid values are an AWS account ID, 'self' (the current account), or an AWS owner alias (e.g. 'amazon', 'aws-marketplace', 'microsoft')."
  type        = string
  default     = "801119661308" // The ID of the owner of the official AWS EKS Windows AMIs.
}

variable "worker_additional_security_group_ids" {
  description = "A list of additional security group ids to attach to worker instances"
  type        = list(string)
  default     = []
}

variable "worker_sg_ingress_from_port" {
  description = "Minimum port number from which pods will accept communication. Must be changed to a lower value if some pods in your cluster will expose a port lower than 1025 (e.g. 22, 80, or 443)."
  type        = number
  default     = 1025
}

variable "workers_additional_policies" {
  description = "Additional policies to be added to workers"
  type        = list(string)
  default     = []
}

variable "kubeconfig_aws_authenticator_command" {
  description = "Command to use to fetch AWS EKS credentials."
  type        = string
  default     = "aws-iam-authenticator"
}

variable "kubeconfig_aws_authenticator_command_args" {
  description = "Default arguments passed to the authenticator command. Defaults to [token -i $cluster_name]."
  type        = list(string)
  default     = []
}

variable "kubeconfig_aws_authenticator_additional_args" {
  description = "Any additional arguments to pass to the authenticator such as the role to assume. e.g. [\"-r\", \"MyEksRole\"]."
  type        = list(string)
  default     = []
}

variable "kubeconfig_aws_authenticator_env_variables" {
  description = "Environment variables that should be used when executing the authenticator. e.g. { AWS_PROFILE = \"eks\"}."
  type        = map(string)
  default     = {}
}

variable "kubeconfig_name" {
  description = "Override the default name used for items kubeconfig."
  type        = string
  default     = ""
}

variable "cluster_create_timeout" {
  description = "Timeout value when creating the EKS cluster."
  type        = string
  default     = "15m"
}

variable "cluster_update_timeout" {
  description = "Timeout value when updating the EKS cluster."
  type        = string
  default     = "15m"
}

variable "cluster_delete_timeout" {
  description = "Timeout value when deleting the EKS cluster."
  type        = string
  default     = "15m"
}

variable "wait_for_cluster_cmd" {
  description = "Custom local-exec command to execute for determining if the eks cluster is healthy. Cluster endpoint will be available as an environment variable called ENDPOINT"
  type        = string
  default     = "until curl -k -s $ENDPOINT/healthz >/dev/null; do sleep 4; done"
}

variable "worker_create_initial_lifecycle_hooks" {
  description = "Whether to create initial lifecycle hooks provided in worker groups."
  type        = bool
  default     = false
}

variable "permissions_boundary" {
  description = "If provided, all IAM roles will be created with this permissions boundary attached."
  type        = string
  default     = null
}

variable "iam_path" {
  description = "If provided, all IAM roles will be created on this path."
  type        = string
  default     = "/"
}

variable "cluster_endpoint_private_access" {
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled."
  type        = bool
  default     = false
}

variable "cluster_endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled."
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "manage_cluster_iam_resources" {
  description = "Whether to let the module manage cluster IAM resources. If set to false, cluster_iam_role_name must be specified."
  type        = bool
  default     = true
}

variable "cluster_iam_role_name" {
  description = "IAM role name for the cluster. Only applicable if manage_cluster_iam_resources is set to false."
  type        = string
  default     = ""
}

variable "manage_worker_iam_resources" {
  description = "Whether to let the module manage worker IAM resources. If set to false, iam_instance_profile_name must be specified for workers."
  type        = bool
  default     = true
}

variable "workers_role_name" {
  description = "User defined workers role name."
  type        = string
  default     = ""
}

variable "attach_worker_cni_policy" {
  description = "Whether to attach the Amazon managed `AmazonEKS_CNI_Policy` IAM policy to the default worker IAM role. WARNING: If set `false` the permissions must be assigned to the `aws-node` DaemonSet pods via another method or nodes will not be able to join the cluster."
  type        = bool
  default     = true
}

variable "create_eks" {
  description = "Controls if EKS resources should be created (it affects almost all resources)"
  type        = bool
  default     = true
}

variable "node_groups_defaults" {
  description = "Map of values to be applied to all node groups. See `node_groups` module's documentaton for more details"
  type        = any
  default     = {}
}

variable "node_groups" {
  description = "Map of map of node groups to create. See `node_groups` module's documentation for more details"
  type        = any
  default     = {}
}

variable "enable_irsa" {
  description = "Whether to create OpenID Connect Provider for EKS to enable IRSA"
  type        = bool
  default     = false
}

variable "eks_oidc_root_ca_thumbprint" {
  type        = string
  description = "Thumbprint of Root CA for EKS OIDC, Valid until 2037"
  default     = "9e99a48a9960b14926bb7f3b02e22da2b0ab7280"
}

variable "force_update_version" {
  description = "force node group to update"
  type        = bool
  default     = false

}

variable "is_default" {
  description = "is the default eks cluster"
  type        = bool
  default     = true
}

variable "node_groups_create_timeout" {
  description = "creation time limit"
  type        = string
  default     = "60m"

}
variable "node_groups_update_timeout" {
  description = "update time limit"
  type        = string
  default     = "3h"

}
variable "node_groups_delete_timeout" {
  description = "deletion time limit"
  type        = string
  default     = "60m"

}
variable "allow_all_egress" {
  description = "trigger to either allow all egress traffic or a more restrictive set"
  type        = bool
  default     = true
}
variable "egress_ports_allowed" {
  description = "ports to allow all egress traffic"
  type        = list(any)
  default     = []
}
variable "egress_cidr_blocks_allowed" {
  description = "cidr blocks to allow all egress traffic"
  type        = list(any)
  default     = []
}
variable "egress_custom_allowed" {
  description = "cidr custom blocks to allow all egress traffic"
  type        = list(any)
  default     = []
}

variable "logging_stage" {
  type        = string
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
}

# EFS CSI driver variables
variable "enable_aws_efs_csi_driver_addon" {
  description = "Whether or not to install the ebs driver addon in the cluster"
  type        = bool
  default     = true
}

variable "aws_efs_csi_driver_version" {
  description = "Version of the efs csi driver container to install"
  type        = string
}

variable "aws_efs_csi_driver_resolve_conflicts" {
  description = "Whether or not to force overwrite of the config. Options: NONE, OVERWRITE"
  type        = string
  default     = "NONE"
}

variable "efs_csi_driver_role_arn" {
  description = "Role for efs csi driver needed by the service accounts to perform ondemand volume resizing"
  type        = string
}

variable "encryption" {
  description = "toggle for enabling encryption"
  type        = bool
  default     = false
}
