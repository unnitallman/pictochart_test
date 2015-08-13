# 2. How would you optimize the following code?

# Original version
def posts_for_30_blogs
  blogs = Blog.limit(30)
  blogs.flat_map do |blog|
    blog.posts.to_a
  end
  # 31 SQL queries
end

# Optimized version
def posts_for_30_blogs
  blogs = Blog.select('id').limit(30)
  Post.where(blog_id: blogs)
  # Down to 2 SQL queries
  # Also fetching only ID of the blogs, and not entire rows.
end
