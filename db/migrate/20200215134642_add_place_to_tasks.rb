class AddPlaceToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :place, :string
  end
end
