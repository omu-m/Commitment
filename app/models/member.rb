class Member < ApplicationRecord

  GUEST_EMAIL = "guest@example.com"

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :task_members, dependent: :destroy
  has_many :request_tasks, dependent: :destroy
  has_many :tasks, through: :task_members
  has_many :owned_tasks, dependent: :destroy, class_name: "Task", foreign_key: "owner_id"
  has_many :task_favorites, dependent: :destroy
  has_many :subtasks, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :activities, dependent: :destroy

  validates :display_name, presence: true, length: { minimum: 2, maximum: 12 }
  validates :user_name, presence: true, uniqueness: true, format: { with: /\A[a-z0-9]+\z/, message: "は半角英数字で入力してください。" }
  validates :email, presence: true, uniqueness: true

  # 名称が部分一致する
  scope :display_name_like, -> name {
    where('display_name like ?', "%#{name}%")
  }

  has_one_attached :profile_image

  # プロフィール画像表示

  def get_profile_image
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpg')
    end
    profile_image
  end

  # is_deletedがfalseならtrueを返すようにしている
  def active_for_authentication?
    super && !is_deleted
  end

  def guest?
    email == GUEST_EMAIL
  end

  # ゲストログイン（閲覧用）
  def self.guest
    find_or_create_by!(email: GUEST_EMAIL) do |member|
      member.password = SecureRandom.urlsafe_base64
      member.user_name = "guestuser"
      member.display_name = "ゲストユーザー"
    end
  end

end
