class Post < ActiveRecord::Base
	belongs_to :user
	has_and_belongs_to_many :categories

	validates :title, presence: true
	validates :url, presence: true
	validate :is_valid_url

	has_many :votes
	has_many :comments

  has_many :post_favourites
	has_many :favourers, through: :post_favourites, :source => :user

	def vote(user, amount)
		vo = self.votes.find_or_initialize_by(user: user)
		vo.amount = amount
		vo.save
		self.compute_score
		self.user.compute_karma
	end

	def score
		self.vote_cache
	end

	def compute_score
		score = 0
		self.votes.each do |vote|
			score += vote.amount
		end

		self.vote_cache = score
		self.save
	end

	def favoured(user)
        return self.favourers.include? user
    end

    def favour(user)
        if not favoured(user)
            self.favourers << user
            self.save
            return true
        end
        return false
    end

    def unfavour(user)
        if favoured(user)
            self.favourers.delete(user)
            self.save
            return true
        end
        return false
    end




	def is_valid_url
		uri = self.url
		require 'uri'
		uri = URI.parse(url)
  		if not  uri.is_a?(URI::HTTP) && !uri.host.nil?
  			errors.add(:url, "must be a valid Url - Sherlock")
  		end
  	rescue URI::InvalidURIError
			errors.add(:url, "must be a valid Url - Sherlock")
	end

end
