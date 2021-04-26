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
end
