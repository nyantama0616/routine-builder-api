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

  # timerableのメソッド名と合わせた
  def passed_seconds
    return 0 unless finished?
    (finished_at - started_at).to_i
  end

  def finish(round_count)
    raise "already finished" if finished_at.present?
    update!(finished_at: Time.current, round_count: round_count)
  end

  def finished?
    finished_at.present?
  end
end
