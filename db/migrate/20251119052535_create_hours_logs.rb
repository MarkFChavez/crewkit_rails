class CreateHoursLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :hours_logs do |t|
      t.references :team_member, null: false, foreign_key: true
      t.date :log_date
      t.decimal :hours
      t.text :deliverable_notes

      t.timestamps
    end
  end
end
