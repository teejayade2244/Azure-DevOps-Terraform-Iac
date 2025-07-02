
#  output "argocd_app_gateway_private_ip" {
#     value       = azurerm_application_gateway.web_app_gateway.frontend_ip_configuration[0].private_ip_address
#     description = "The private IP address of the Application Gateway for Argo CD UI access."
#   }