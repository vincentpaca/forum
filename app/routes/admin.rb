class Application < Sinatra::Application

  before %r{/admin/?} do
    redirect '/' if current_user.nil?
    redirect '/' unless current_user.is_admin?
  end

  get '/admin/' do
    "admin dashboardi #{current_user.name}"
  end

  get '/admin/new_topic/?' do
    haml :new_topic, :layout => :admin_layout, :locals => { :topics => Topic.all }
  end

  post '/admin/save_topic/?' do
    Topic.create!(:title => params[:title])
    redirect '/admin/new_topic'
  end

end
