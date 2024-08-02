class CreateConsumables < ActiveRecord::Migration[7.1]
  def change
    create_table :consumables do |t|

      t.timestamps
    end
  end
end
