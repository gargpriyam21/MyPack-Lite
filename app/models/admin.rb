class Admin < ApplicationRecord
  has_secure_password
  belongs_to :user, dependent: :destroy
end
