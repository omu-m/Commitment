class Member < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :task_members, dependent: :destroy
  has_many :tasks, through: :task_members

  validates :display_name, presence: true
  validates :user_name, presence: true, uniqueness: true, format: { with: /\A[a-z0-9]+\z/, message: "は半角英数字で入力してください。" }
  validates :email, presence: true, uniqueness: true

  # is_deletedがfalseならtrueを返すようにしている
  def active_for_authentication?
    super && (is_deleted == false)
  end

  # ゲストログイン（閲覧用）
  def self.guest
    find_or_create_by!(user_name: "guestuser",email: "guest@example.com") do |member|
      member.password = SecureRandom.urlsafe_base64
      member.display_name = "ゲストユーザー"
      member.email = "guest@example.com"
    end
  end

end
