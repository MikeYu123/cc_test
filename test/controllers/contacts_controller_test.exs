defmodule TestTaskContacts.ContactsControllerTest do
  use TestTaskContacts.ConnCase
  alias TestTaskContacts.Router
  # @opts Router.init([])

  def test_data do
  	{:ok, data} = %{phonebook: [%{
  		name: "Mikey",
  		contacts: %{
	  		email: ["mikesehse@gmail.com"],
	  		phone: ["79166366499"]
  		}}]}
  		|> Poison.encode;
  	data
  end

  def reset_conn(conn) do
  	conn
  		|> recycle()
  		|> put_req_header("accept", "application/json")
    	|> put_req_header("content-type", "application/json")
  end

  setup do
    conn = build_conn()
    	|> reset_conn
    {:ok, conn: conn}
  end

  test "POST /api/contacts returns respective data and assigns guids", %{conn: conn} do
    conn = post conn, "/api/contacts", test_data()
   	response = json_response(conn, 200)
   	assert length(response) == 1
   	[user|_] = response
   	assert length(user["contacts"]) == 2
   	assert Enum.any?(user["contacts"], fn contact ->
   						contact["type"] == "phone" 
   						&& contact["value"] == "79166366499" 
   						&& contact["guid"] != "" end)
   	assert Enum.any?(user["contacts"], fn contact ->
   						contact["type"] == "email" 
   						&& contact["value"] == "mikesehse@gmail.com"
   						&& contact["guid"] != "" end)		
  end

  test "POST /api/contacts does not reass guids 2", %{conn: conn} do
    conn = post conn, "/api/contacts", test_data()
   	response1 = json_response(conn, 200)
   	conn = reset_conn(conn)
   	conn = post conn, "/api/contacts", test_data()
   	response2 = json_response(conn, 200)
   	assert response1 == response2
  end
end
