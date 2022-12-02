class AddOrderToTasks < ActiveRecord::Migration[7.0]
  def change
    change_table :tasks do |t|
      t.integer :project_order
    end
    # add_column :tasks, :project_order, :integer
  end
end
