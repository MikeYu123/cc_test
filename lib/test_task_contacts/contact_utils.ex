defmodule TestTaskContacts.ContactUtils do
	alias TestTaskContacts.User, as: User
	defp connection do
		Bolt.Sips.conn
	end

	def process_phonebook(phonebook) do
		phonebook["phonebook"]
		  |> Enum.map(fn user_data -> 
		  					%User{name: user_data["name"], contacts: fetch_contacts(user_data["contacts"])} end)
		  |> Enum.map(fn user -> process_user(user) end)
	end

	defp fetch_contacts(user_data) do
		Enum.map(["phone", "email"], fn type -> 
			Enum.map(user_data[type], fn value ->
				%Contact{type: type, value: to_string(value)}
			end)
		end)
		|> List.flatten
	end

	def process_user(user) do
		user_lookup_query = TestTaskContacts.Neo4jUtils.lookup_user_query(user.name)
		lookup_result = Bolt.Sips.query!(connection, user_lookup_query)
		if lookup_result == [] do
			user_create_query = TestTaskContacts.Neo4jUtils.create_user_query(user.name)
			Bolt.Sips.query!(connection, user_create_query)
		end
		updated_contacts = Enum.map(user.contacts, fn contact -> process_contact(contact) end)
		Enum.each(user.contacts, fn contact -> connect_user_with_contact(user, contact) end)
		%{ user | contacts: updated_contacts}
	end

	def process_contact(contact) do
		lookup_query = case contact.type do
		    "phone" ->
		   		TestTaskContacts.Neo4jUtils.lookup_phone_query(contact.value)
		   	"email" ->
		   		TestTaskContacts.Neo4jUtils.lookup_email_query(contact.value)
		end
		lookup_result = Bolt.Sips.query!(connection, lookup_query)
		guid = if lookup_result == [] do
			generated_guid = UUID.uuid4
			create_query = case contact.type do
			    "phone" ->
			   		TestTaskContacts.Neo4jUtils.create_phone_query(contact.value, generated_guid)
			   	"email" ->
			   		TestTaskContacts.Neo4jUtils.create_email_query(contact.value, generated_guid)
			end
			Bolt.Sips.query!(connection, create_query)
			generated_guid
		else
			[found_guid|_] = lookup_result
			found_guid["guid"]
		end
		%{contact | guid: guid}
	end

	def connect_user_with_contact(user, contact) do
		lookup_query = TestTaskContacts.Neo4jUtils.lookup_has_relationship(user.name, contact.value)
		lookup_result = Bolt.Sips.query!(connection, lookup_query)
		if lookup_result == [] do
			create_query = TestTaskContacts.Neo4jUtils.create_has_relationship(user.name, contact.value)
			Bolt.Sips.query!(connection, create_query)
		end
	end
end