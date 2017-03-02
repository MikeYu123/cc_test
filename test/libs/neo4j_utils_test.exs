defmodule TestTaskContacts.Neo4jUtilsTest do
	use ExUnit.Case
	alias TestTaskContacts.Neo4jUtils


	test "lookup_user_query" do 
		name = "mikey"
		target = "MATCH (user:user {name: 'mikey'}) RETURN user"
		query = Neo4jUtils.lookup_user_query(name)
		assert query == target
	end

	test "create_user_query" do 
		name = "mikey"
		target = "CREATE (user:user {name: 'mikey'})"
		query = Neo4jUtils.create_user_query(name)
		assert query == target
	end

	test "create_phone_query" do 
		phone = "79166366499"
		guid = "7ba6bbd5-2b94-4e47-a309-bca1156094c4"
		target = "CREATE (phone:phone:contact {value: '79166366499', guid: '7ba6bbd5-2b94-4e47-a309-bca1156094c4'})"
		query = Neo4jUtils.create_phone_query(phone, guid)
		assert query == target
	end

	test "lookup_phone_query" do 
		phone = "79166366499"
		target = "MATCH (phone:phone:contact {value: '79166366499'}) RETURN phone.guid as guid"
		query = Neo4jUtils.lookup_phone_query(phone)
		assert query == target
	end

	test "create_email_query" do 
		email = "mikesehse@gmail.com"
		guid = "7ba6bbd5-2b94-4e47-a309-bca1156094c4"
		target = "CREATE (email:email:contact {value: 'mikesehse@gmail.com', guid: '7ba6bbd5-2b94-4e47-a309-bca1156094c4'})"
		query = Neo4jUtils.create_email_query(email, guid)
		assert query == target
	end

	test "lookup_email_query" do 
		email = "mikesehse@gmail.com"
		target = "MATCH (email:email:contact {value: 'mikesehse@gmail.com'}) RETURN email.guid as guid"
		query = Neo4jUtils.lookup_email_query(email)
		assert query == target
	end

	test "create_has_relationship" do 
		email = "mikesehse@gmail.com"
		name = "mikey"
		target = "MATCH (user:user {name: 'mikey'}), (contact:contact {value: 'mikesehse@gmail.com'}) CREATE (user)-[r:has]->(contact)"
		query = Neo4jUtils.create_has_relationship(name, email)
		assert query == target
	end

	test "lookup_has_relationship" do 
		email = "mikesehse@gmail.com"
		name = "mikey"
		target = "MATCH (user:user {name: 'mikey'})-[r:has]->(contact:contact {value: 'mikesehse@gmail.com'}) RETURN r" 
		query = Neo4jUtils.lookup_has_relationship(name, email)
		assert query == target
	end

end