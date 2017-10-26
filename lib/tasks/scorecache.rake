namespace :scorecache do

  desc "Recalculate All Caches"
  task :all => :environment do
    Rake::Task['scorecache:posts'].execute
    Rake::Task['scorecache:users'].execute
  end

  desc "Recalculate Score Cache for all Posts"
  task :posts => :environment do
    puts "Rebuilding Score Cache for all Post..."
    Post.find_each do |post|
        score_before = post.score
        post.compute_score
        post.compute_heat
        post.save
        puts "#{post.id} - score #{post.score}, heat #{post.heat}"
        if post.score != score_before
          warn("CACHE WAS INCONSISTENT!")
        end
      end
  end

  desc "Recalculate Karma Cache for all Users"
  task :users => :environment do
    puts "Rebuilding Score Cache for all Users..."
    User.find_each do |user|
        score_before = user.karma
        user.compute_karma
        puts "#{user.id} - karma #{user.karma}"
        if user.karma != score_before
          warn("CACHE WAS INCONSISTENT!")
        end
      end
  end


end
