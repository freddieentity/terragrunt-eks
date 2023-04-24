variable "helm_releases" {
    type = any
    default = {
        ingress-nginx = {
            name       = "ingress-nginx"
            repository = "https://kubernetes.github.io/ingress-nginx"
            chart      = "ingress-nginx"
            version    = "4.0.6"
            wait = false
            timeout   = "1200"

            namespace        = "ingress-nginx"
            create_namespace = true

            values = [
                "${file("/values/ingress-nginx-values.yaml")}"
            ]

            override_values = {
                test = "justtest"
            }
        },
        cert-manager = {
            name       = "ingress-nginx"
            repository = "https://kubernetes.github.io/ingress-nginx"
            chart      = "ingress-nginx"
            version    = "4.0.6"
            wait = false
            timeout   = "1200"

            namespace        = "ingress-nginx"
            create_namespace = true

            values = [
                "${file("/values/cert-manager-values.yaml")}"
            ]       
            override_values = {}  
        }
    }
}