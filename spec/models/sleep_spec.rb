require 'rails_helper'

RSpec.describe Sleep, type: :model do
  before do
    @sleep = create(:sleep)
  end

  it "started_atがデフォルトでnilであること" do
    expect(@sleep.started_at).to eq nil
  end

  it "finished_atがデフォルトでnilであること" do
    expect(@sleep.finished_at).to eq nil
  end

  it "nap?がdefaultでfalseであること" do
    expect(@sleep.nap?).to eq false
  end

  it "infoで、startedAt, finishedAt, isNapを返す" do
    expect(@sleep.info).to eq({
      startedAt: @sleep.started_at,
      finishedAt: @sleep.finished_at,
      isNap: @sleep.nap?,
    })
  end

  it "sleep#startで、started_atが現在時刻(Tokyo)になり、nap?がfalseになる" do
    @sleep.start
    expect(@sleep.started_at).to be_within(1.second).of(Time.current)
    expect(@sleep.started_at.zone).to eq 'JST'
    expect(@sleep.nap?).to eq false
  end

  it "sleep#start(nap: true)で、nap?がtrueになる" do
    @sleep.start(nap: true)
    expect(@sleep.nap?).to eq true
  end

  it "sleep#startを2回実行すると、エラーになる" do
    @sleep.start
    expect { @sleep.start }.to raise_error('already started')
  end

  it "finish済みの状態でsleep#startを実行すると、エラーになる" do
    @sleep.start
    @sleep.finish
    expect { @sleep.start }.to raise_error('already finished')
  end

  it "sleep#finishで、finished_atが現在時刻になる" do
    @sleep.start
    @sleep.finish
    expect(@sleep.finished_at).to be_within(1.second).of(Time.current)
  end

  it "sleep#startを実行する前に、sleep#finishを実行すると、エラーになる" do
    expect { @sleep.finish }.to raise_error('not started')
  end

  it "sleep#finishを2回実行すると、エラーになる" do
    @sleep.start
    @sleep.finish
    expect { @sleep.finish }.to raise_error('already finished')
  end
end
