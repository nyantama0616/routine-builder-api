class AddLifeToSleeps < ActiveRecord::Migration[7.0]
  def change
    add_reference :sleeps, :life, null: false, foreign_key: true
  end
end
