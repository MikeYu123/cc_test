defmodule TestTaskContacts.ContactsController do
  use TestTaskContacts.Web, :controller

  # plug :action

  def index(conn, _params) do
    text conn, "Pass contacts to same address using POST method"
  end

  def add(conn, _params) do
  	{:ok, body, _conn} = Plug.Conn.read_body(conn)
  	response = TestTaskContacts.ContactUtils.process_phonebook(conn.body_params)
    json conn, response
  end
end
