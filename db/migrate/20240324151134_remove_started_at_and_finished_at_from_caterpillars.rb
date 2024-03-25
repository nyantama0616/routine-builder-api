class RemoveStartedAtAndFinishedAtFromCaterpillars < ActiveRecord::Migration[7.0]
  def change
    remove_column :caterpillars, :started_at, :datetime
    remove_column :caterpillars, :finished_at, :datetime
  end
end
