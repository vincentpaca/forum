module ViewHelpers

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

end
