output "identity_id" {
  value       = azurerm_user_assigned_identity.aks_identity.id
  description = "The ID of the User Assigned Identity created for AKS."
}

output "identity_principal_id" {
  value       = azurerm_user_assigned_identity.aks_identity.principal_id
  description = "The principal ID of the User Assigned Identity created for AKS."
}