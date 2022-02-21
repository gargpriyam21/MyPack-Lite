class Admin < ApplicationRecord
  has_secure_password
  belongs_to :user, dependent: :destroy
  validates :name, :email, :password_digest, :phone_number, presence: true

  validate :admin_count_within_limit, :on => :create

  def admin_count_within_limit
    if Admin.count >= 1
      errors.add(:base, "Exceeded thing limit")
    end
  end
end
