# frozen_string_literal: true

module AuthHelper
  def http_login
    before do
      user = 'foo'
      pw = 'bar'
      stub_const('LOGINS', user => Digest::MD5.hexdigest(pw.to_s))
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user, pw)
    end
  end
end
