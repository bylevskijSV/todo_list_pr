class Task < ApplicationRecord
  belongs_to :user

  validates :description, presence: true, length: { minimum: 10, maximum: 300 }
  validates :title, presence: true, length: { minimum: 3, maximum: 100 }

  STATUSES = [
    NEW = 'new',
    IN_PROGRESS = 'in progress',
    DONE = 'done'
  ]

  def complete!
    update_column(:status, Task::DONE)
  end
end
