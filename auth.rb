SCOPES = [
  'https://www.googleapis.com/auth/userinfo.email'
].join(' ')
G_API_CLIENT = '1019829380574-clpop0ig8gof5fslif562r4c4ujgc7n4.apps.googleusercontent.com'.freeze
G_API_SECRET = '5HGCEgpLlXbkFnFXOcLBj5JG'.freeze

def client
  client ||= OAuth2::Client.new(G_API_CLIENT, G_API_SECRET, site: 'https://accounts.google.com',
                                                            authorize_url: '/o/oauth2/auth',
                                                            token_url: '/o/oauth2/token')
end

def connected?
  redirect '/auth' if session[:user].nil?
end

before do
  connected? unless ['/', '/auth', '/oauth2callback'].include? request.path
end
get '/auth' do
  redirect client.auth_code.authorize_url(redirect_uri: redirect_uri, scope: SCOPES, access_type: 'offline')
end

get '/oauth2callback' do
  access_token = client.auth_code.get_token(params[:code], redirect_uri: redirect_uri)
  session[:access_token] = access_token.token
  @message = 'Successfully authenticated with the server'
  @access_token = session[:access_token]

  # parsed is a handy method on an OAuth2::Response object that will
  # intelligently try and parse the response.body
  p @email = access_token.get('https://www.googleapis.com/userinfo/email?alt=json').parsed

  if @email['data']['isVerified'] && @email['data']['email'] == 'nicolas.roitero@gmail.com'
    session[:user] = @email['data']['email']
    redirect '/admin'
  else
    redirect '/auth'
  end
end

def redirect_uri
  uri = URI.parse(request.url)
  uri.path = '/oauth2callback'
  uri.query = nil
  uri.to_s
end
