class Customer < ActiveRecord::Base
  has_many :nodes, dependent: :destroy

  validates :name, presence: true
  validates :enrollment_secret, presence: true, uniqueness: true
end