require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end
  
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:status) }
    
    it 'validates that due_date is not in the past' do
      user = create(:user)
      task = build(:task, user: user, due_date: Date.yesterday)
      
      expect(task).not_to be_valid
      expect(task.errors[:due_date]).to include('cannot be in the past')
    end
    
    it 'allows due_date to be today or in the future' do
      user = create(:user)
      task = build(:task, user: user, due_date: Date.current)
      
      expect(task).to be_valid
    end
  end
  
  describe 'enums' do
    it 'defines status enum correctly' do
      user = create(:user)
      task = create(:task, user: user, status: 'pending')
      
      expect(task.pending?).to be true
      expect(task.in_progress?).to be false
      expect(task.done?).to be false
    end
  end
end

