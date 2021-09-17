class Task < ApplicationRecord
  belongs_to :user

  validates :description, presence: true, length: { minimum: 10, maximum: 300 }
  validates :title, presence: true, length: { minimum: 3, maximum: 100 }

  
end
