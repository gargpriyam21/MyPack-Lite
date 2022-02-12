class User < ApplicationRecord
  has_one :instructor
  has_one :student
  has_one :admin
end
