class Task < ApplicationRecord
  belongs_to :user
  
  enum status: {
    pending: 'pending',
    in_progress: 'in_progress',
    done: 'done'
  }
  
  validates :title, presence: true
  validates :status, presence: true
  validate :due_date_not_in_past
  
  private
  
  def due_date_not_in_past
    return unless due_date.present?
    
    if due_date < Date.current
      errors.add(:due_date, 'cannot be in the past')
    end
  end
end

