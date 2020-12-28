locals {
  global  = yamldecode(file(find_in_parent_folders("global.yaml")))
  account = yamldecode(file(find_in_parent_folders("account.yaml")))
  region  = yamldecode(file(find_in_parent_folders("region.yaml")))
  env     = yamldecode(file(find_in_parent_folders("env.yaml")))
  modules = yamldecode(file(find_in_parent_folders("modules.yaml")))
}

terraform {
  source = local.modules.eks_config
}

include {
  path = find_in_parent_folders()
}

dependency "cluster" {
  config_path = "../cluster"
}

dependency "route53_public" {
  config_path = "../../route53-public"
}

inputs = {
  cluster_name = dependency.cluster.outputs.cluster_id

  aws_alb_ingress_controller = {
    version = "1.0.4"
    extra_sets = {
      "image.tag" : "v1.1.8"
    }
  }

  aws_node_termination_handler = {
    version = "0.13.2"
    extra_sets = {
      "image.tag" : "v1.11.2"
    }
  }

  node_problem_detector = {
    version = "1.8.3"
    extra_sets = {
      "image.repository" : "k8s.gcr.io/node-problem-detector/node-problem-detector"
      "image.tag" : "v0.8.5"
    }
  }

  kube_downscaler = {
    version = "0.6.2"
    extra_sets = {
      "image.tag" : "20.10.0"
    }
  }

  kube_state_metrics = {
    version = "2.9.4"
    extra_sets = {
      "image.tag" : "v1.9.7"
    }
  }

  metrics_server = {
    version = "2.11.4"
    extra_sets = {
      "image.repository" : "k8s.gcr.io/metrics-server/metrics-server"
      "image.tag" : "v0.4.1"
    }
  }

  external_dns = {
    version          = "4.0.0"
    route53_zone_ids = [values(dependency.route53_public.outputs.this_route53_zone_zone_id)[0]]
    extra_sets = {
      "image.tag" : "0.7.4"
    }
  }

  cluster_autoscaler = {
    version = "9.3.0"
    extra_sets = {
      "image.repository" : "k8s.gcr.io/autoscaling/cluster-autoscaler"
      "image.tag" : "v1.17.3"
    }
  }
}
