defmodule TestTaskContacts.ContactUtilsTest do
	use ExUnit.Case
	alias TestTaskContacts.ContactUtils

	test "process_phonebook assigns correct values" do
		# Deatomize keys
		sample_data = %{phonebook: 
							[%{name: "mikey", 
								contacts:
									%{phone: ["79166366499"], email: ["mikesehse@gmail.com"]}}]}
				|> Poison.encode!
				|> Poison.decode!
		result = ContactUtils.process_phonebook(sample_data)
		assert length(result) == 1
		[user | _] = result
		assert user.name == "mikey"
		assert Enum.any?(user.contacts, fn contact ->
   						contact.type == "phone" 
   						&& contact.value == "79166366499" 
   						&& contact.guid != "" end)
   		assert Enum.any?(user.contacts, fn contact ->
   						contact.type == "email" 
   						&& contact.value == "mikesehse@gmail.com"
   						&& contact.guid != "" end)
	end

	# TODO: Other tests(using mocks)

end