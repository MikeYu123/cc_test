defmodule TestTaskContacts.Neo4jUtils do
	def create_phone_query(phone, guid) do
		"CREATE (phone:phone:contact {value: '#{phone}', guid: '#{guid}'})"
	end

	def lookup_phone_query(phone) do
		"MATCH (phone:phone:contact {value: '#{phone}'}) RETURN phone.guid as guid"
	end

	def create_email_query(email, guid) do
		"CREATE (email:email:contact {value: '#{email}', guid: '#{guid}'})"
	end

	def lookup_email_query(email) do
		"MATCH (email:email:contact {value: '#{email}'}) RETURN email.guid as guid"
	end

	def lookup_user_query(user_name) do
		"MATCH (user:user {name: '#{user_name}'}) RETURN user"
	end

	def create_user_query(user_name) do
		"CREATE (user:user {name: '#{user_name}'})"
	end

	def create_has_relationship(user_name, contact) do
		"MATCH (user:user {name: '#{user_name}'}), (contact:contact {value: '#{contact}'}) CREATE (user)-[r:has]->(contact)"
	end


	def lookup_has_relationship(user_name, contact) do
		"MATCH (user:user {name: '#{user_name}'})-[r:has]->(contact:contact {value: '#{contact}'}) RETURN r"
	end
end 