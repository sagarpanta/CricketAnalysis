class ClientMailer < ActionMailer::Base
  default from: "cricitdown@gmail.com"
  def registration_confirmation(client)
	@client = client
    mail(:to => client.email, :subject => "Registered")
  end
  
  def temporary_password(client)
	@client = client
    mail(:to => client.email, :subject => "temporary password")
  end
  
  def send_temp_password(client, temppass)
	@client = client
	@temppass = temppass
    mail(:to => client.email, :subject => "temporary password")
  end  
  
  def Error_Delivery(message, client, caught_at)
	@message = message
    mail(:to => 'cricitdown@gmail.com', :subject => "Error:"+client.name+" caught at:"+caught_at)
  end
  
end
