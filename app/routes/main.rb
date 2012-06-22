class Application < Sinatra::Application

  get '/?' do
    haml :index, :locals => { :current_user => current_user, :topics => topic_list, :posts => post_list(Post.all) }
  end

  get '/topics/:id/?' do |id|
    @topic = Topic.find(id)
    haml :index, :locals => { :current_user => current_user, :topics => topic_list, :posts => post_list(@topic.posts) }
  end

  get '/topics/:id/json' do |id|
    @topic = Topic.find(id)
    { :topic => @topic, :posts => post_list(@topic.posts) }.to_json
  end

  get '/posts/:id/?' do |id|
    @post = Post.find(id)
    @topics = Topic.all

    haml :post, :locals => { :current_user => current_user, :topics => topic_list, :post => @post }
  end

  get '/posts/new/?' do
    
  end
 
end
