class AddDefaultValueToStatus < ActiveRecord::Migration[6.1]
  def change
    change_table :tasks do |t|
      t.change_default(:status, from: nil, to: "new")
    end
  end
end
