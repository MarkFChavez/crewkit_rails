class CreateAttendanceRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :attendance_records do |t|
      t.references :team_member, null: false, foreign_key: true
      t.date :record_date
      t.integer :status
      t.text :notes

      t.timestamps
    end
  end
end
