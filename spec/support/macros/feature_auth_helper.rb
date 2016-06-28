module FeatureAuthHelper
  def login
    user = 'foo'
    pw = 'bar'
    stub_const("LOGINS", { user => Digest::MD5.hexdigest("#{pw}") })

    page.driver.browser.basic_authorize(user, pw)
  end
end
