class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :posts
  has_many :categories
  has_many :votes
  has_many :comments

  def score
    score = 0
    self.posts.each do |post|
      score += post.score
    end
    return score
  end

end
