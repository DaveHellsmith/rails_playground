class Company < ApplicationRecord
  has_many :deals, dependent: :restrict_with_exception
end
