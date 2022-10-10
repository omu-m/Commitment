class Member < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :task_members, dependent: :destroy
  has_many :tasks, through: :task_members, dependent: :destroy

  validates :display_name, presence: true
  validates :user_name, presence: true, uniqueness: true, format: { with: /\A[a-z0-9]+\z/, message: "は半角英数字で入力してください。" }
  validates :email, presence: true, uniqueness: true

  # is_deletedがfalseならtrueを返すようにしている
  def active_for_authentication?
    super && (is_deleted == false)
  end

end
