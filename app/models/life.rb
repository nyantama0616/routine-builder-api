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

  def start
    raise 'already finished' if has_finished?
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

  def drink(xml)
    check_valid!
    self.water += xml.to_i
    save!
  end

  private

  def check_valid!
    raise 'already finished' if has_finished?
    raise 'not started' unless has_started?
  end
end
