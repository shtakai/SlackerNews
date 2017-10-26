class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :name, presence: true

  has_many :posts
  has_many :categories
  has_many :votes
  has_many :comments

  has_many :category_subscriptions
  has_many :subscriptions, through: :category_subscriptions, :source => :category
  has_many :post_favourites
  has_many :favourites, through: :post_favourites, :source => :post

  as_enum :role, user: 1, mod: 2, admin: 3

  def karma
    karma_cache
  end

  def compute_karma
    karma = 0
    self.posts.each do |post|
      karma += post.score
    end
    self.karma_cache = karma
    self.save
  end

end
