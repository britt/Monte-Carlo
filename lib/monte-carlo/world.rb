# Represents the state of the simulation world at a given time.

module MonteCarlo
  class World
    attr_reader :current_events, :history, :clock
    
    def initialize(clock = false)
      @clock = clock || SimpleClock.new
      @current_events = []
      @history = {}
    end
    
    def current_time
      @clock.time
    end
    
    def tick
      @history[current_time] = current_events
      @current_events = []
      @clock.tick
    end
    
    def add_event(name, value, creator)
      @current_events << Event.new(name, value, creator, current_time)
    end
    
    def current_state
      "#{current_time} ::: #{current_events.inspect}"
    end
    
    private
    
    class SimpleClock
      def initialize
        @ticks = 0
      end
      
      def time 
        @ticks
      end
      
      def tick
        @ticks += 1
      end
    end
  end
end