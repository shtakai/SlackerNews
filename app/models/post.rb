class Post < ActiveRecord::Base
	default_scope { where(status_cd: 1) }


	belongs_to :user
	has_and_belongs_to_many :categories

	validates :title, presence: true
	
	validates :url, presence: true
	validate :is_valid_url
	validates_uniqueness_of :url
	validates :categories, presence: true

	has_many :votes
	has_many :comments

    has_many :post_favourites
	has_many :favourers, through: :post_favourites, :source => :user

	after_create :compute_heat

	as_enum :status, pending: 0, published: 1, deleted: 2

	searchable_attributes :title, :description

	# sorting stuff
	VALID_SORT_ORDERS = %w(best newest hot)

	scope :best, -> { order(vote_cache: :desc)}
	scope :newest, -> { order(created_at: :desc)}
	scope :hot, -> { order(heat: :desc)}


	# a very good thing to get from global settings
	self.per_page = 3

	# ============================
	# Class Methods
	# ============================


	# ============================
	# Instance Methods
	# ============================

	def vote(user, amount)
		vo = self.votes.find_or_initialize_by(user: user)
		vo.amount = amount
		vo.save
		self.compute_score
		self.compute_heat
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

	def compute_heat
		timestamp = self.created_at.to_i
		factor = 8.hours.to_i

		# simple algo for now
		self.heat = timestamp + ( self.score * factor )
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
