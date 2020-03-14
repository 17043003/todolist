class AddReferencesToTagFromTasks < ActiveRecord::Migration[5.2]
  def change
    add_reference :tasks, :tag, index: true
  end
end
