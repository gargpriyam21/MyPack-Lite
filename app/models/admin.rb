class Admin < ApplicationRecord
  has_secure_password
  belongs_to :user, dependent: :destroy
  validates :name, :email, :password_digest, :phone_number, presence: true

  validates :phone_number, format: {
    with: /\A(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}\z/,
    message: "Not Valid"
  }

  validate :admin_count_within_limit, :on => :create

  def admin_count_within_limit
    if Admin.count >= 1
      errors.add(:base, "Exceeded thing limit")
    end
  end
end
