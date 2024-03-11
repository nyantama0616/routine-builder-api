class Sleep < ApplicationRecord
  def info
    {
      startedAt: started_at,
      finishedAt: finished_at,
      isNap: nap?,
    }
  end

  def start(nap: false)
    raise 'already finished' if has_finished?
    raise 'already started' if has_started?
    update(started_at: Time.current, nap: nap)
  end

  def has_started?
    started_at.present?
  end

  def finish
    raise 'not started' unless has_started?
    raise 'already finished' if has_finished?
    update(finished_at: Time.current)
  end

  def has_finished?
    finished_at.present?
  end
end
