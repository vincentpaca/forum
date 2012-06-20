require 'koala'
require 'oauth'
require 'twitter'
require 'json'

class Routes < Sinatra::Base
  include Koala
  enable :sessions

  get '/?' do
    erb :index, :locals => { :current_user => current_user, :topics => topic_list, :posts => post_list(Post.all) }
  end

  #auth ------
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
  #end auth ------

  get '/topics/:id/?' do |id|
    @topic = Topic.find(id)
    erb :index, :locals => { :current_user => current_user, :topics => topic_list, :posts => post_list(@topic.posts) }
  end

  get '/topics/:id/json' do |id|
    @topic = Topic.find(id)
    { :topic => @topic, :posts => post_list(@topic.posts) }.to_json
  end

  get '/posts/:id/?' do |id|
    @post = Post.find(id)
    @topics = Topic.all

    erb :post, :locals => { :current_user => current_user, :topics => topic_list, :post => @post }
  end

  get '/posts/new/?' do
    
  end
  
  #helpers ------
  helpers do
    def topic_list
      @topics = Topic.all
      @topic_list = "<ul>"
      @topics.each do |topic|
        @topic_list += "<li><a class='sidebar-topic' id='#{topic.id}' href='/topics/#{topic._id}'>#{topic.title}</a></li>"
      end
      @topic_list += "</ul>"
      @topic_list
    end

    def post_list(posts)
      @post_list = "<ul>"
      posts.each do |post|
        @post_list += "<li><a class='post-list' id='#{post.id}' href='/posts/#{post._id}'>#{post.title}</a></li>"
      end
      @post_list += "</ul>"
      @post_list
    end

    def current_user
      session['current_user']
    end

    def base_url
      @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
    end

    def link_to (url, display, a_class)
      "<a href='/#{url}' class='#{a_class}'>#{display}</a>"
    end

    def time_ago(time, options = {})
      start_date = options.delete(:start_date) || Time.new
      date_format = options.delete(:date_format) || :default
      delta_minutes = (start_date.to_i - time.to_i).floor / 60
      if delta_minutes.abs <= (8724*60)       
        distance = distance_of_time_in_words(delta_minutes)       
        if delta_minutes < 0
          return "#{distance} from now"
        else
          return "#{distance} ago"
        end
      else
        return "on #{DateTime.now.to_formatted_s(date_format)}"
      end
    end
 
    def distance_of_time_in_words(minutes)
      case
        when minutes < 1
          "less than a minute"
        when minutes < 50
          "#{minutes} minutes"
        when minutes < 90
          "about one hour"
        when minutes < 1080
          "#{(minutes / 60).round} hours"
        when minutes < 1440
          "one day"
        when minutes < 2880
          "about one day"
        else
          "#{(minutes / 1440).round} days"
      end
    end
  end
  #end helpers ------
end


