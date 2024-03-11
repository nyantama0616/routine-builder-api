class Sleep < ApplicationRecord
  def start
    raise 'already started' if has_started?
    update(started_at: Time.current)
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
