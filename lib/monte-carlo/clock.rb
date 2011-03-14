require 'date'
require 'active_support'

module MonteCarlo
  class Clock
    def initialize(start_date, step_size = nil)
      @time = start_date
      @step_size = step_size || 1.hour
    end

    def time 
      @time
    end

    def tick
      @time += @step_size
    end
  end
end