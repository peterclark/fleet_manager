class Node < ActiveRecord::Base
  belongs_to :customer

  validates :node_key, presence: true, uniqueness: true
end