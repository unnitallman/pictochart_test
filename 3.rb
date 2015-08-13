# 3. What flaw do you see in this code? How would you REFACTOR it?

class BlogPostsController < ApplicationController
  def index
    @published_posts   = BlogPost.where(‘published_at <= ?’, Time.now)
    @unpublished_posts = BlogPost.where(‘published_at = ? OR published_at > ?’,
nil, Time.now)
  end
end