require 'http'
require 'uri'

class NeonMob
  URL = URI('https://www.neonmob.com')

  def initialize(username, password)
    @password = password
    @username = username
  end

  def login
    @login = post('/api/signin/', login_params).parse
  end

  private

  def logged_in?
    @login['code'].nil?
  end

  def login_params
    {
      :password => @password,
      :username => @username,
    }
  end

  def post(path, params = {})
    HTTP[:accept => "application/json"].post(build_url(path), :json => params)
  end

  def build_url(path)
    URL.tap do |uri|
      uri.path = path
    end.to_s
  end
end
