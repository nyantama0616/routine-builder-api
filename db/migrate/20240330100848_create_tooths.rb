class CreateTooths < ActiveRecord::Migration[7.0]
  def change
    create_table :tooths do |t|
      t.references :life, null: false, foreign_key: true
      t.timestamps
    end
  end
end
