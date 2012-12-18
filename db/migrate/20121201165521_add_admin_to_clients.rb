class AddAdminToClients < ActiveRecord::Migration
	CLIENTS = [
			{:username => 'admin', :name => 'administrator',:email=>'cricitdown@gmail.com', :encrypted_password=>'123456', :encrypted_password_confirmation=>'123456', :country=>'NEPAL', :actype=>'Premium' }
	]

	def change
		CLIENTS.each do |c|
			client = Client.create(c)
			client.save
		end
	end
end
