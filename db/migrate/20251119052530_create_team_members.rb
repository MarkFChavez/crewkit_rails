class CreateTeamMembers < ActiveRecord::Migration[8.0]
  def change
    create_table :team_members do |t|
      t.references :team, null: false, foreign_key: true
      t.string :name
      t.string :role
      t.string :email
      t.string :phone

      t.timestamps
    end
  end
end
