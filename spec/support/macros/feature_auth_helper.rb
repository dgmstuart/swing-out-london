# frozen_string_literal: true

module FeatureAuthHelper
  def login
    user = 'foo'
    pw = 'bar'
    stub_const('LOGINS', user => Digest::MD5.hexdigest(pw.to_s))

    page.driver.browser.basic_authorize(user, pw)
  end
end
