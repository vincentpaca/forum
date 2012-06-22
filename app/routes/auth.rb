class Application < Sinatra::Application
  include Koala

  get '/facebook/connect/?' do
    session['oauth'] = Facebook::OAuth.new(FB_APP_ID, FB_SECRET, base_url + '/facebook/callback')
    redirect session['oauth'].url_for_oauth_code()
  end

  get '/twitter/connect/?' do
    #session['oauth'] = OAuth::Consumer.new(TW_KEY, TW_SECRET, { :site => 'http://api.twitter.com' })
    #request_token = session['oauth'].get_request_token(:oauth_callback => base_url + '/twitter/callback')
    #session['token'] = request_token.token
    #session['secret'] = request_token.secret
    #redirect "http://api.twitter.com/oauth/authorize?oauth_token=#{session['token']}"
    redirect '/'
  end

  get '/logout/?' do
    session['oauth'] = nil
    session['current_user'] = nil
    redirect '/'
  end

  get '/facebook/callback/?' do
    access_token = session['oauth'].get_access_token(params[:code])
    graph = Facebook::API.new(access_token)
    person = graph.get_object("me")
    session['current_user'] = User.find_or_create_by(:fb_id => person['id'], :name => person['name'], :access_token => access_token)
    if session['current_user']
      session['current_user'].update_attribute(:last_login, Time.now)
    end
    redirect '/'
  end
  
  get '/twitter/callback/?' do
    #request = OAuth::RequestToken.new(session['oauth'], session['token'], session['secret'])
    #access = request.get_access_token(:oauth_verifier => params[:oauth_verifier])
    #response = session['oauth'].request(:get, '/account/verify_credentials.json', access, { :scheme => :query_string })
    #user_info = JSON.parse(response.body)
    #user_info
    redirect '/'
  end
 
end
