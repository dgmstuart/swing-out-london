module AuthHelper
  def http_login
    before(:each) do
      user = 'dgms'
      pw = 'Tatgdsd75'
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user,pw)
    end
  end  
end