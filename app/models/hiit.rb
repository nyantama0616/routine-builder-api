class Hiit
  class << self
    private

    def define_accessor(category, *methods)
      dir = "db/data/#{Rails.env}"
      methods.each do |method_name|
        
        #getter
        define_singleton_method(method_name) do
          json = JSON.parse(File.read("#{dir}/hiit.json")).deep_symbolize_keys
          json[category][method_name]
        end

        #setter
        define_singleton_method("#{method_name}=") do |value|
          json = JSON.parse(File.read("#{dir}/hiit.json")).deep_symbolize_keys
          json[category][method_name] = value
          File.write("#{dir}/hiit.json", JSON.pretty_generate(json))
        end
      end
    end
  end

  define_accessor :hiit, :work_time, :break_time, :round_count
end
