class Sleep < ApplicationRecord
  class << self
    def create_and_start(nap: false)
      sleep = Sleep.create(life: Life.today)
      sleep.start nap: nap
      sleep
    end
  end

  belongs_to :life
  
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

    # 睡眠が終わったら、Lifeが終了し、新しいLifeが始まる
    # TODO: この設計は正しいのか。。。
    unless nap?
      life.finish
      life = Life.create
      life.start
    end
  end

  def has_finished?
    finished_at.present?
  end
end
