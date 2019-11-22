module Mailer extend ActiveSupport::Concern

    def send_email(to, subject,body)
        valid = false
        api_key = "key-22d493e96d695def4b734719e5f15abd"
        domain = "mg.ethicsglobal.com"

        data = {}
		data[:from] = "no-reply@mg.ethicsglobal.com"
		data[:to] = to
		data[:subject] = subject
		data[:html] = body.to_str
        
        r = RestClient.post "https://api:#{api_key}@api.mailgun.net/v3/#{domain}/messages", data
        response = JSON.parse(r)		  
        if ("Queued. Thank you.").include? response["message"]
            valid = true
        end
        valid
    end
end