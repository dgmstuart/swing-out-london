# frozen_string_literal: true

class FacebookAccessTokensController < CmsBaseController
  layout "cms"

  def refresh
    response_body = FacebookGraphApi::TokenApi.new.exchange_token(current_user.token)
    token_data = RefreshGraphTokenResponse.new(response_body)

    login_session.set_token!(token: token_data.token, token_expires_at: token_data.token_expires_at)

    redirect_to account_path
  end
end
