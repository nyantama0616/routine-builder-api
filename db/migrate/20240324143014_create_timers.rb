class CreateTimers < ActiveRecord::Migration[7.0]
  def change
    create_table :timers do |t|
      t.boolean :running, null: false, default: false
      t.integer :passed_seconds_when_stopped, null: false, default: 0
      t.datetime :started_at
      t.datetime :finished_at
      t.timestamps
    end
  end
end
