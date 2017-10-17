class Category < ActiveRecord::Base
	has_and_belongs_to_many :posts
	belongs_to :user
    has_many :category_subscriptions
    has_many :subscribers, through: :category_subscriptions, :source => :user


    def subscribed(user)
        return self.subscribers.include? user
    end

    def subscribe(user)
        if not subscribed(user)
            self.subscribers << user
            self.save
            return true
        end
        return false
    end

    def unsubscribe(user)
        if subscribed(user)
            self.subscribers.delete(user)
            self.save
            return true
        end
        return false
    end

end