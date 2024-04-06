class AddFinishedAtToHiits < ActiveRecord::Migration[7.0]
  def change
    add_column :hiits, :finished_at, :datetime
  end
end
