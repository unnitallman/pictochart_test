# 3. What flaw do you see in this code? How would you REFACTOR it?

# Original version
class BlogPostsController < ApplicationController
  def index
    @published_posts   = BlogPost.where('published_at <= ?', Time.now)
    @unpublished_posts = BlogPost.where('published_at = ? OR published_at > ?',
nil, Time.now)
  end
end

#----------------------------------------------------------------------
# Refactored version

# Changes made:
#  1. (published_at = ?, nil) doesn't generate the correct sql query as one would expect.
#     Replaced it with 'published_at is null'
#
#  2. used the same 'current time' while fetching published and unpublished posts.
#     there is a slim chance of inconsistency otherwise, if a user publishes a post
#     in the split second time interval between the fetching of @published_posts and
#     @unpublished_posts
#
#  3. Moved the business logic from the conrtoller to the model.
#     Makes it reusable and easy to unit test.

class BlogPostsController < ApplicationController
  def index
    time_now = Time.now
    @published_posts   = BlogPost.published time_now
    @unpublished_posts = BlogPost.unpublished time_now
  end
end

# Model
class BlogPost < ActiveRectimee
  scope :published, -> (time) {
    where('published_at is not null AND published_at <= ?', time)
  }

  scope :unpublished, -> (time) {
    where('published_at is null OR published_at > ?', time)
  }
end