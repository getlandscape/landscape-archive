require "oauth2"

APP_HOST   = ENV['LANDSCAPE_APP_HOST']
APP_KEY    = ENV['LANDSCAPE_APP_KEY']
APP_SECRET = ENV['LANDSCAPE_APP_SECRET']
USERNAME   = ENV['LANDSCAPE_USERNAME']
PASSWORD   = ENV['LANDSCAPE_PASSWORD']

client = OAuth2::Client.new(APP_KEY, APP_SECRET, site: APP_HOST)
access_token = client.password.get_token(USERNAME, PASSWORD)
res = Faraday.get("#{APP_HOST}/api/v3/hello.json?access_token=#{access_token.token}")
puts res.status
puts res.body
