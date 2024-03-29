class Timer < ApplicationRecord
  belongs_to :target, polymorphic: true, optional: true
  
  def passed_seconds
    if  running?
      (Time.current - started_at).to_i + passed_seconds_when_stopped
    else
      passed_seconds_when_stopped
    end
  end

  def start
    raise "Timer has already finished." if finished?
    raise "Timer has already started." if started?
    update!(running: true, started_at: Time.current)
  end

  def stop
    raise "Timer has already finished." if finished?
    raise "Timer has not started." if stopped?
    update!(running: false, passed_seconds_when_stopped: passed_seconds)
  end

  def finish
    raise "Timer has already finished." if finished?
    raise "Timer has not started." if started_at.blank?
    update!(running: false, passed_seconds_when_stopped: passed_seconds, finished_at: Time.current)
  end

  def started?
    started_at.present? && running?
  end

  def stopped?
    !running?
  end

  def finished?
    finished_at.present?
  end

  def info
    {
      isRunning: running?,
      startedAt: started_at.iso8601,
      passedSecondsWhenStopped: passed_seconds_when_stopped,
    }
  end
end
