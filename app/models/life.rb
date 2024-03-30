# Lifeクラスの寿命は、その日起きてから、次の日起きるまで！
class Life < ApplicationRecord
  class << self
    alias :today :last
    
    def create_and_start
      life = create
      life.start
      life
    end
  end

  has_many :sleeps, dependent: :destroy
  has_many :caterpillars, dependent: :destroy
  has_many :hiits, dependent: :destroy
  has_many :hanons, dependent: :destroy
  has_many :tooths, dependent: :destroy

  def start
    raise 'already finished' if finished?
    raise 'already started' if started?
    update(started_at: Time.current)
  end

  def started?
    started_at.present?
  end

  def finish
    raise 'not started' unless started?
    raise 'already finished' if finished?
    update(finished_at: Time.current)
  end

  def finished?
    finished_at.present?
  end

  def drink_water(xml)
    check_valid!
    self.water += xml.to_i
    save!
  end

  #TODO: coffeeとかも追加
  def water_info
    {
      water: water,
    }
  end

  def status
    if (sleep = sleeps.last) && !sleep.finished?
      sleep.nap? ? Status::Nap : Status::Sleep
    elsif (cat = caterpillars.last) && cat.timer.running?
      Status::Caterpillar
    elsif (hanon = hanons.last) && hanon.timer.running?
      Status::Hanon
    elsif (tooth = tooths.last) && tooth.timer.running?
      Status::Tooth
    else
      Status::None
    end
  end

  def info
    {
      startedAt: started_at,
      status: status,
    }
  end

  private

  def check_valid!
    raise 'already finished' if finished?
    raise 'not started' unless started?
  end
end
