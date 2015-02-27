require 'google/api_client'
class GoogleTokenRefresher
  attr_reader :client, :auth
  def refresh!
    setup_auth
    print("1. Open this page:\n%s\n\n" % auth.authorization_uri)
    print("2. Enter the authorization code shown in the page: ")
    auth.code = $stdin.gets.chomp
    auth.fetch_access_token!
    access_token = auth.access_token
    puts "GOOGLE_DRIVE_TOKEN=\"#{access_token}\""
  end

  def client
    @client = Google::APIClient.new
  end

  def setup_auth
    auth = client.authorization
    auth.client_id = ENV['GOOGLE_CLIENT_ID']
    auth.client_secret = ENV['GOOGLE_CLIENT_SECRET']
    auth.scope =
      "https://www.googleapis.com/auth/drive " +
      "https://spreadsheets.google.com/feeds/"
    auth.redirect_uri = "urn:ietf:wg:oauth:2.0:oob"
    @auth = auth
  end
end
