class Hiit < ApplicationRecord
  class << self
    #行ったラウンド数を渡す
    def create_train!(params)
      Hiit.create!(
        round_count: params[:round_count],
        work_time: params[:work_time] || Hiit.work_time,
        break_time: params[:break_time] || Hiit.break_time, 
        life: Life.today
      )
    end

    def update_setting!(params)
      Hiit.work_time = params[:work_time] || Hiit.work_time
      Hiit.break_time = params[:break_time] || Hiit.break_time
      Hiit.round_count = params[:round_count] || Hiit.round_count
    end

    def setting_info
      {
        roundCount: Hiit.round_count,
        workTime: Hiit.work_time,
        breakTime: Hiit.break_time
      }
    end

    private

    def define_accessor(*methods)
      dir = "db/data/#{Rails.env}"
      methods.each do |method_name|
        
        #getter
        define_singleton_method(method_name) do
          json = JSON.parse(File.read("#{dir}/hiit.json")).deep_symbolize_keys
          json[method_name]
        end

        #setter
        define_singleton_method("#{method_name}=") do |value|
          raise "value must be Integer" if value.class != Integer

          json = JSON.parse(File.read("#{dir}/hiit.json")).deep_symbolize_keys
          json[method_name] = value
          File.write("#{dir}/hiit.json", JSON.pretty_generate(json))
        end
      end
    end

    def create_file_if_not_exist!
      path = "db/data/#{Rails.env}/hiit.json"
      return if File.exist?(path)

      File.write(path, JSON.pretty_generate({ work_time: 0, break_time: 0, round_count: 0 }))
    end
  end

  belongs_to :life

  define_accessor :work_time, :break_time, :round_count
  create_file_if_not_exist!

  with_options presence: true do
    validates :work_time
    validates :break_time
    validates :round_count
  end

  def info
    {
      workTime: work_time,
      breakTime: break_time,
      roundCount: round_count
    }
  end
end
