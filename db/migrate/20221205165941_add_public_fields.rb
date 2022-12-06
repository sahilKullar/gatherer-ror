class AddPublicFields < ActiveRecord::Migration[7.0]
  def change
    change_table :projects do |t|
      t.boolean :public, default: false
    end

    change_table :users do |t|
      t.boolean :admin, default: false
    end
  end
end
