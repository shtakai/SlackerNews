namespace :initialize_comment_count do
  desc "Sets the counter of comments in a post instance to the right number"
  task :initialize => [ :environment ] do
    Post.find_each { |post| Post.reset_counters(post.id, :comments) }
  end
end
