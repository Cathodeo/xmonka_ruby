class AddNameToStatuses < ActiveRecord::Migration[7.1]
  def change
    add_column :statuses, :name, :string
  end
end
