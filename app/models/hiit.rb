class Hiit < ApplicationRecord
  include ClassMethods

  belongs_to :life

  define_accessor :work_time, :break_time, :round_count
  create_file_if_not_exist!

  with_options presence: true do
    validates :work_time
    validates :break_time
    validates :round_count
  end

  def started_at
    created_at
  end

  def info
    {
      workTime: work_time,
      breakTime: break_time,
      roundCount: round_count,
      startedAt: started_at,
      finishedAt: finished_at
    }
  end

  def finish
    raise "already finished" if finished_at.present?
    update!(finished_at: Time.current)
  end
end
