workspace "App ABC Architecture" {
	model {
		internalClient = softwareSystem "Internal Clients"
		gateway = softwareSystem "Apigee Gateway"
		gtm = softwareSystem "AVI Global Traffic Manager" "HA routing across datacenters"
		app = softwareSystem "Application" "My application desc" "Active-Active, tag2" {
			backend = container "Backend" "API Layer" "Java/Spring"
			database = container "Database" "Data Storage" "PostgreSQL"
		}
		internalClient -> gateway "Calls API"
		gateway -> gtm "Global Routing"
		gtm -> backend "Routes Requests"
		backend -> database "Queries"
		
		production = deploymentEnvironment "Production" {
			k8sCluster = deploymentNode "Kubernetes Cluster" "Openshift" {
				appDeployment = deploymentNode "Application" "" "" {
					backendInstance = containerInstance backend
				}
			}
			ingress = deploymentNode "Ingress" "" {
				gatewayInstance = softwareSystemInstance gateway
				gtmInstance = softwareSystemInstance gtm
			}
		}
	}
	views {
		systemContext app "SystemContext" {
			include *
			include internalClient
			include gateway
			autoLayout
		}
		container app "Containers" {
			include *
			include internalClient
			include gateway
			autoLayout
		}
		deployment app production "K8sDeployment" "Production Deployment in Kubernetes" {
			include *
			autoLayout
		}
	}
}