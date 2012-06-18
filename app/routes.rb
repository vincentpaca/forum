require 'koala'
class Routes < Sinatra::Base
  include Koala
  enable :sessions

  get '/?' do
    if logged_in?
      @current_user = session['current_user']
      erb :index    
    else
      redirect '/login'
    end
  end

  get '/login/?' do
    unless logged_in?
      erb :login
    else
      redirect '/'
    end
  end

  get '/facebook/connect/?' do
    session['oauth'] = Facebook::OAuth.new(FB_APP_ID, FB_SECRET, base_url + '/callback')
    redirect session['oauth'].url_for_oauth_code()
  end

  get '/logout/?' do
    session['oauth'] = nil
    session['current_user'] = nil
    redirect '/'
  end

  get '/callback/?' do
    access_token = session['oauth'].get_access_token(params[:code])
    graph = Facebook::API.new(access_token)
    person = graph.get_object("me")
    session['current_user_photo'] = 
    session['current_user'] = User.find_or_create_by(:fb_id => person['id'], :name => person['name'], :access_token => access_token)
	redirect '/'
  end

  helpers do
    def base_url
      @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
    end

    def logged_in?
      session['current_user'] ? true : false
    end

    def link_to (url, display)
      "<a href='/#{url}'>#{display}</a>"
    end
  end
end


