class Member < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :task_members, dependent: :destroy
  has_many :tasks, through: :task_members
  has_many :tasks, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :subtasks, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :display_name, presence: true
  validates :user_name, presence: true, uniqueness: true, format: { with: /\A[a-z0-9]+\z/, message: "は半角英数字で入力してください。" }
  validates :email, presence: true, uniqueness: true

  has_one_attached :profile_image

  # プロフィール画像表示
  def get_profile_image
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpeg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpeg', content_type: 'image/jpeg')
    end
    profile_image
  end

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
