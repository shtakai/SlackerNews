class Category < ActiveRecord::Base
	has_and_belongs_to_many :posts
	belongs_to :user
    
    has_many :category_subscriptions
    has_many :subscribers, through: :category_subscriptions, :source => :user

    has_many :sub_categories, class_name: "Category", foreign_key: "parent_category_id"
    belongs_to :parent_category, class_name: "Category"

    validates_uniqueness_of :slug
    validates_uniqueness_of :name
    validates :slug, presence: true
    validates :name, presence: true

    searchable_attributes :name, :desc


    # size of page in frontend (has nothing to do with db pagination)
    self.per_page = 20

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


    # returns own sub_categories and their's (recursively)
    def all_sub_categories
        # watch out, self is not included in here
        self.sub_categories.map do |category|
            [category] + category.all_sub_categories
        end.flatten
    end


    def all_posts
        category_ids = self.all_sub_categories.map{|c| c.id}
        # add self, because sub categories has only the subs
        category_ids << self.id

        return Post.select{|p| p.categories.any? {|c| category_ids.include? c.id }}
        # return Post.select{|p| category_ids.include? p.category}
    end

      def to_param  # overridden
          slug
      end


    private

    def parent_not_self
        # check that the parent_category is not the same 
        # select box should not show that in the first place
        
    end

end