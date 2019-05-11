class Member < ActiveRecord::Base
  has_many :articles
  has_many :statistics, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :kakao_chat_logins, dependent: :destroy
  belongs_to :major
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_format_of :tel, with: /\A(01[016789]{1}|02|0[3-9]{1}[0-9]{1})[0-9]{3,4}[0-9]{4}\z/
  validates_format_of :email, with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
end
