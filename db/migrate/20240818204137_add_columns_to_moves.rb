class AddColumnsToMoves < ActiveRecord::Migration[7.1]
  def change
    add_column :moves, :is_status, :boolean
    add_column :moves, :status_id, :integer
    add_column :moves, :coin_damage, :boolean
    add_column :moves, :coin_status, :boolean
    add_column :moves, :number_hits, :integer
    add_column :moves, :is_specific_element, :boolean
    add_column :moves, :limit_element, :integer
    add_column :moves, :weakness_bypass, :boolean
    add_column :moves, :weakness_element, :integer
    add_column :moves, :force_switch, :boolean
    add_column :moves, :prevent_switch, :boolean
    add_column :moves, :vamp, :boolean
  end
end
