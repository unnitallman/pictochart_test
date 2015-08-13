# 1. What is one major concern of the following code and how would you improve it?

class BlogPostsController < ApplicationController
  # allows user to rename their blog
  def rename
    # @blogpost = Blogpost.find(params[:id])

    # 1. This find is not scoped to the user. He could edit the title of
    #    any blog post (even the ones which belongs to others)

    @blogpost = current_user.blog_posts.find(params[:id])

    # if @blogpost.update_attribute(:title, sanitize(params[:title]))

    # 2. update_attribute will not trigger validations and hence the '500'
    #    is not going to be sent as expected, in the case of an invalid title.

    if @blogpost.update_attributes(title: params[:title])
      format.json { render json: { status: 200 } }
    else
      format.json { render json: { status: 500 } }
    end
  end
end