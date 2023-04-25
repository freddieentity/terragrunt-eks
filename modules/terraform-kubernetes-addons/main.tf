resource "helm_release" "this" {
  for_each   = var.helm_releases
  name       = each.key
  repository = each.value.repository
  chart      = each.value.chart
  version    = each.value.version
  wait       = each.value.wait
  timeout    = each.value.timeout

  namespace        = each.value.namespace
  create_namespace = each.value.create_namespace

  values = each.value.values
  #   dynamic "set" {
  #     iterator = each_item
  #     for_each = try(var.override_values, null)

  #     content {
  #       name  = each_item.value.name
  #       value = each_item.value.value
  #       type  = try(each_item.value.type, null)
  #     }
  #   }
}

# resource "null_resource" "wait_for" {
#   triggers = {
#     key = uuid()
#   }

#   provisioner "local-exec" {
#     command = <<EOF
#       printf "\nWaiting for the Nginx ingress controller...\n"
#       kubectl wait --namespace ${helm_release.ingress_nginx.namespace} \
#         --for=condition=ready pod \
#         --selector=app.kubernetes.io/component=controller \
#         --timeout=90s
#     EOF
#   }

#   depends_on = [helm_release.ingress_nginx]
# }