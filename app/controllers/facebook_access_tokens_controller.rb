# frozen_string_literal: true

require "facebook_graph_api/token_api"

class FacebookAccessTokensController < CmsBaseController
  layout "cms"

  def refresh
    response = FacebookGraphApi::TokenApi.new.exchange_token(login_session.user.token)

    response_data = JSON.parse(response)

    request.session[:user]["token"] = response_data.fetch("access_token")
    request.session[:user]["token_expires_at"] = response_data.fetch("expires_in")

    redirect_to account_path
  end
end
