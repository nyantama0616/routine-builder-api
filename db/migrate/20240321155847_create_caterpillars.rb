class CreateCaterpillars < ActiveRecord::Migration[7.0]
  def change
    create_table :caterpillars do |t|
      t.references :life, null: false, foreign_key: true
      t.string :pattern, null: false
      t.datetime :started_at
      t.datetime :finished_at
      t.timestamps
    end
  end
end
