class CreateEquipables < ActiveRecord::Migration[7.1]
  def change
    create_table :equipables do |t|

      t.timestamps
    end
  end
end
