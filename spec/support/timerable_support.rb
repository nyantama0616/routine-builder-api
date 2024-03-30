RSpec.shared_examples "timerable" do |block|
  before do
    Life.create_and_start
    @model = block&.call
  end

  it "has one timer" do
    expect(@model.timer).to be_present
  end

  it "destroys timer when destroyed" do
    timer = @model.timer
    @model.destroy
    expect(Timer.find_by(id: timer.id)).to be_nil
  end

  it "start" do
    @model.stop
    @model.start
    expect(@model.timer.started?).to be true
  end

  it "stop" do
    @model.stop
    expect(@model.timer.stopped?).to be true
  end

  it "finish" do
    @model.finish
    expect(@model.timer.finished?).to be true
  end
end
