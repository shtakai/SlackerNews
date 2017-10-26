namespace :scorecache do

  desc "Recalculate All Caches"
  task :all => :environment do
    Rake::Task['scorecache:posts'].execute
    Rake::Task['scorecache:users'].execute
  end

  desc "Recalculate Score Cache for all Posts"
  task :posts => :environment do
    puts "Rebuilding Score Cache for all Post..."
    Post.find_each { |post|
      begin
        scoreBefore = post.score
        post.compute_score
        puts "#{post.id} - score #{post.score}"
        if post.score != scoreBefore
          warn("CACHE WAS INCONSISTENT!")
        end
      end
    }
  end

  desc "Recalculate Karma Cache for all Users"
  task :users => :environment do
    puts "Rebuilding Score Cache for all Users..."
    User.find_each { |user|
      begin
        scoreBefore = user.karma
        user.compute_karma
        puts "#{user.id} - karma #{user.karma}"
        if user.karma != scoreBefore
          warn("CACHE WAS INCONSISTENT!")
        end
      end
    }
  end


end
