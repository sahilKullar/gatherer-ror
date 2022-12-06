class AddUserToTask < ActiveRecord::Migration[7.0]
  def change
    change_table :tasks do |t|
      t.references :user
    end
    change_table :users do |t|
      t.string :twitter_handle
    end
  end
end
