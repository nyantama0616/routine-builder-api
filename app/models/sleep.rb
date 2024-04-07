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
    raise 'already finished' if finished?
    raise 'already started' if started?
    update(started_at: Time.current, nap: nap)
  end

  def finish
    raise 'not started' unless started?
    raise 'already finished' if finished?
    update(finished_at: Time.current)

    # 睡眠が終わったら、Lifeが終了し、新しいLifeが始まる
    # TODO: この設計は正しいのか。。。
    unless nap?
      life.finish
      life = Life.create
      life.start
    end
  end

  def started?
    started_at.present?
  end

  def finished?
    finished_at.present?
  end

  def passed_seconds
    return 0 unless finished?
    (finished_at - started_at).to_i
  end
end
