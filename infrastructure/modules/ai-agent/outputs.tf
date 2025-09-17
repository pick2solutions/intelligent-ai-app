output "agent_ids" {
  value = {
    for name, agent in restapi_object.agents : name => agent.api_data.id
  }
  description = "A map of agent names to their IDs."
}