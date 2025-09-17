terraform {
  required_version = ">= 1.10.0"

  required_providers {
    restapi = {
      source                = "mastercard/restapi"
      version               = "2.0.1"
      configuration_aliases = [restapi.ai_foundry]
    }
  }
}

resource "restapi_object" "agents" {
  provider = restapi.ai_foundry

  for_each = var.agents

  path                      = "/assistants"
  query_string              = "api-version=v1"
  ignore_all_server_changes = true

  data = jsonencode(merge(
    each.value,
    {
      model = lookup(each.value, "model", var.default_model)
      metadata = merge(
        lookup(each.value, "metadata", {}),
        { managed_by = "terraform" }
      )
    }
  ))

  id_attribute   = "id"
  create_method  = "POST"
  destroy_method = "DELETE"
  destroy_path   = "/assistants/{id}"

  lifecycle {
    create_before_destroy = false
  }
}

