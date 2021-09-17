class ChangeAssignedIdToAssingedTo < ActiveRecord::Migration[6.1]
  def change
    change_table :tasks do |t|
      t.rename(:assigned_id, :assigned_to_id)
    end
  end
end
