class CreateTeams < ActiveRecord::Migration[8.0]
  def change
    create_table :teams do |t|
      t.string :name
      t.string :company
      t.text :description
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
