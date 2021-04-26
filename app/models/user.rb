class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :tweets
  has_many :comments
  has_many :relationships # データを取得するための入り口(フォロー)
  has_many :followings, through: :relationships, source: :follow # データを取得後の出口(フォロー)
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id' # 入り口(フォロワー)
  has_many :followers, through: :reverse_of_relationships, source: :user # 出口(フォロワー)
  
  validates :nickname, presence: true, length: { maximum: 6 }

  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end
end
