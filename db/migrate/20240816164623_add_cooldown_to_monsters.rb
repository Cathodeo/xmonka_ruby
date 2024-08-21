class AddCooldownToMonsters < ActiveRecord::Migration[7.1]
  def change
    add_column :monsters, :cooldown, :integer
  end
end
