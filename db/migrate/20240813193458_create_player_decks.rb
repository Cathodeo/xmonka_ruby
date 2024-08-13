class CreatePlayerDecks < ActiveRecord::Migration[7.1]
  def change
    create_table :player_decks do |t|
      t.references :user, null: false, foreign_key: true
      t.text :deck_data

      t.timestamps
    end
  end
end
