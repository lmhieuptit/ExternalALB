project_id       = "externalalb"
region_primary   = "asia-northeast1"
region_secondary = "asia-northeast2"

//------------------------------------------VPC Network----------------------------------------------------------------//
vpc_name = "my-vpc-network"

vpc_subnets = {
  public-subnet-web-asia-northeast1 = {
    name                     = "public-subnet-web-asia-northeast1"
    cidr                     = "10.0.0.0/24"
    region                   = "asia-northeast1"
    private_ip_google_access = false
  }

  private-subnet-app-asia-northeast1 = {
    name                     = "private-subnet-app-asia-northeast1"
    cidr                     = "10.0.1.0/24"
    region                   = "asia-northeast1"
    private_ip_google_access = true
  }

  private-subnet-database-asia-northeast1 = {
    name                     = "private-subnet-database-asia-northeast1"
    cidr                     = "10.0.2.0/24"
    region                   = "asia-northeast1"
    private_ip_google_access = true
  }

  private-subnet-direct-vpc-asia-northeast1 = {
    name                     = "private-subnet-direct-vpc-asia-northeast1"
    cidr                     = "10.0.3.0/24"
    region                   = "asia-northeast1"
    private_ip_google_access = true
  }

  public-subnet-web-asia-northeast2 = {
    name                     = "public-subnet-web-asia-northeast2"
    cidr                     = "10.1.0.0/24"
    region                   = "asia-northeast2"
    private_ip_google_access = false
  }

  private-subnet-app-asia-northeast2 = {
    name                     = "private-subnet-app-asia-northeast2"
    cidr                     = "10.1.1.0/24"
    region                   = "asia-northeast2"
    private_ip_google_access = true
  }

  private-subnet-database-asia-northeast2 = {
    name                     = "private-subnet-database-asia-northeast2"
    cidr                     = "10.1.2.0/24"
    region                   = "asia-northeast2"
    private_ip_google_access = true
  }
  
  private-subnet-direct-vpc-asia-northeast2 = {
    name                     = "private-subnet-direct-vpc-asia-northeast2"
    cidr                     = "10.1.3.0/24"
    region                   = "asia-northeast2"
    private_ip_google_access = true
  }
}
vpc_subnets_proxy = {
  "proxy-asia-northeast1" : {
    proxy_only_subnet_name = "proxy-only-asia-northeast1"
    proxy_only_subnet_cidr = "10.129.0.0/23"
    region                 = "asia-northeast1"
  },
  "proxy-asia-northeast2" : {
    proxy_only_subnet_name = "proxy-only-asia-northeast2"
    proxy_only_subnet_cidr = "10.130.0.0/23"
    region                 = "asia-northeast2"
  }
}

/* Firewall Rules */
public_subnet_web_tag            = "web-tag"
private_subnet_app_tag           = "app-tag"
private_subnet_database_tag      = "database-tag"
private_subnet_direct_to_vpc_tag = "direct-to-vpc-tag"


//----------------------------------------------Cloud Run-------------------------------------------------------------------//
cloud_run_services = {
  service1 = {
    name           = "frontend-public-service"
    container_name = "container-frontend-public-service"
    docker_image   = "docker.io/okteto/hello-world:latest"
    region         = "asia-northeast1"
    minScale       = "0"
    maxScale       = "5"
    ingress        = "internal-and-cloud-load-balancing"
    env = {
      DATABASE_URL = "some-internal-db-url"
      LOG_LEVEL    = "INFO"
    }
    port = 8080
  }
  service2 = {
    name           = "frontend-admin-service"
    container_name = "container-frontend-admin-service"
    docker_image   = "us-docker.pkg.dev/cloudrun/container/hello:latest"
    region         = "asia-northeast1"
    minScale       = "0"
    maxScale       = "5"
    ingress        = "internal-and-cloud-load-balancing"
    env = {
      DATABASE_URL = "some-internal-db-url"
      LOG_LEVEL    = "INFO"
    }
    port = 8080
  }
  service3 = {
    name           = "frontend-apis-service"
    container_name = "container-frontend-apis-service"
    docker_image   = "phanhoang102/docker-example-nextjs:latest"
    region         = "asia-northeast1"
    minScale       = "0"
    maxScale       = "5"
    ingress        = "internal-and-cloud-load-balancing"
    env = {
      DATABASE_URL = "some-internal-db-url"
      LOG_LEVEL    = "INFO"
    }
    port           = 8080
  }
  service4 = {
    name           = "backend-message-board-api-service"
    container_name = "container-backend-message-board-api-service"
    docker_image   = "phanhoang102/docker-example-nextjs:latest"
    region         = "asia-northeast1"
    minScale       = "0"
    maxScale       = "5"
    ingress        = "internal-and-cloud-load-balancing"
    env = {
      NEXT_PUBLIC_API_URL = "http://service.internal-alb.example.com/notification/get"
    }
    port           = 3000
    vpc_network    = "my-vpc-network"
    vpc_subnetwork = "private-subnet-direct-vpc-asia-northeast1"
  }
  service5 = {
    name           = "public-web-service"
    container_name = "container-public-web"
    docker_image   = "us-docker.pkg.dev/cloudrun/container/hello:latest"
    region         = "asia-northeast2"
    minScale       = "0"
    maxScale       = "5"
    ingress        = "all"
    env = {
      NEXT_PUBLIC_API_URL = "http://service.internal-alb.example.com/notification/get"
    }
    port           = 8080
    vpc_network    = "my-vpc-network"
    vpc_subnetwork = "private-subnet-direct-vpc-asia-northeast2"
  }
}


//------------------------------------------Network Services---------------------------------------------------------------//
/* Cloud DNS */
cloud_dns_name             = "alb-internal-private-zone"
cloud_dns_dns_name         = "internal-alb.example.com."
google_dns_record_set_name = "service"

/* Load Balancing */
internal_cloud_run_neg_app = {
  neg-app-message-asia-northeast1 : {
    name : "neg-app-message-asia-northeast1",
    service_name : "frontend-api-service"
    region : "asia-northeast1"
  }
  neg-app-notification-asia-northeast1 : {
    name : "neg-app-notification-asia-northeast1",
    service_name : "frontend-public-service"
    region : "asia-northeast1"
  }
  neg-app-notification-asia-northeast2 : {
    name : "neg-app-notification-asia-northeast2",
    service_name : "frontend-public-service"
    region : "asia-northeast2"
  }
}

internal_url_map_host_rules = [
  {
    hosts        = ["*"]
    path_matcher = "path-matcher-1"
  }
]

internal_url_map_path_matchers = [
  {
    name                = "path-matcher-1"
    default_service_key = "neg-app-notification-asia-northeast1"
    path_rules = [
      {
        paths       = ["/notification", "/notification/*"]
        service_key = "neg-app-message-asia-northeast1"
      },
      {
        paths       = ["/v1/notification", "/v1/notification/*"]
        service_key = "neg-app-message-asia-northeast1"
        route_action = {
          url_rewrite = {
            path_prefix_rewrite = "/notification/"
          }
        }
      }
    ]
  }
]

internal_load_balancer_name_app      = "my-loadbalancer-app-internal"
internal_load_balancing_scheme_app   = "INTERNAL_MANAGED"
internal_url_map_default_service_key = "neg-app-message-asia-northeast1"

external_cloud_run_neg_web = {
  "neg-apis-web-primary" : {
    name : "neg-apis-web-primary",
    service_name : "apis-web-service",
    region : "asia-northeast1"
  },
  "neg-apis-web-secondary" : {
    name : "neg-apis-web-secondary",
    service_name : "apis-web-service",
    region : "asia-northeast2"
  }
}
external_backend_services_config = {
  "apis-web-global-backend" : {
    port_name = "http",
    backends = [
      {
        neg_key         = "neg-apis-web-primary"
        capacity_scaler = 1.0
      },
      {
        neg_key         = "neg-apis-web-secondary"
        capacity_scaler = 0.0
      }
    ]
  }
}
external_load_balancer_name_web      = "my-loadbalancer-app-external"
external_load_balancing_scheme_web   = "EXTERNAL_MANAGED"
external_url_map_default_service_key = "apis-web-global-backend"

//-----------------------------------------------------------------Compute Engine--------------------------------------------------------//
zone          = "asia-northeast1-a"
instance_name = "my-instance"
machine_type  = "e2-micro"
image         = "ubuntu-os-cloud/ubuntu-2204-lts"
