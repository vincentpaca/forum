require 'koala'
class Routes < Sinatra::Base
  include Koala
  enable :sessions

  get '/?' do
    if session['current_user']
      @current_user = session['current_user']
    end
    
    @topics = Topic.all
    @topic_list = "<ul>"
    @topics.each do |topic|
      @topic_list += "<li><a href='/topics/#{topic.urlify}'>#{topic.title}</a></li>"
    end
    @topic_list += "</ul>"

    erb :index, :locals => { :current_user => @current_user, :topics => @topic_list }
  end

  get '/facebook/connect/?' do
    session['oauth'] = Facebook::OAuth.new(FB_APP_ID, FB_SECRET, base_url + '/callback')
    redirect session['oauth'].url_for_oauth_code()
  end

  get '/twitter/connect/?' do
    redirect '/'
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

  get '/topic/:topic_title/?' do
    
  end

  helpers do
    def base_url
      @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
    end

    def link_to (url, display, a_class)
      "<a href='/#{url}' class='#{a_class}'>#{display}</a>"
    end
  end
end


