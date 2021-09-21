require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:task) { FactoryBot.create(:task) }

  context 'after create' do
    it 'has status "new"' do
      expect(task.status).to eq('new')
    end
  end

  context 'validates' do
    it 'has a empty title' do
      expect(FactoryBot.build(:task, title: '')).to_not be_valid
    end

    it 'has a empty description' do
      task = FactoryBot.build(:task, description: '')
      expect(task).to_not be_valid
    end
  end

  context 'the name of the person who assigned the task' do
    let(:assigned_user) { FactoryBot.create(:user) }
    let(:parent_user) { FactoryBot.create(:user, first_name: 'parent', last_name: 'last') }
    it 'a method parent_name' do
      task = FactoryBot.create(:task, user_id: assigned_user.id, assigned_to_id: parent_user.id)
      expect(task.assigned_to_full_name).to eq('parent last')
    end
  end

  context 'Checking if the task has been completed' do
    it 'send predicate task_done?' do
      expect(task.task_done?).to_not eq(true)
    end
  end

  context 'change status' do
    it 'send method complete!' do
      task = FactoryBot.create(:task)
      task.complete!
      expect(task.status).to eq('done')
    end
  end
end