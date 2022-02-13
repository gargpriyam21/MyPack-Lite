class User < ApplicationRecord
  has_one :instructor, dependent: :destroy
  has_one :student, dependent: :destroy
  has_one :admin, dependent: :destroy
end
