class AddTargetToTimers < ActiveRecord::Migration[7.0]
  def change
    add_reference :timers, :target, polymorphic: true
  end
end
