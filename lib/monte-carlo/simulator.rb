# Runs the simulation and marks time.

module MonteCarlo
  class Simulator
    attr_accessor :agents, :generators, :world, :logger, :clock
    
    def initialize(world, generators = [], agents = [], opts = {})
      self.world = world
      self.agents = agents
      self.generators = generators
      self.clock = opts[:clock] || SimpleClock.new
      self.logger = opts[:logger] || Logger.new
    end
    
    def run
    end
    
    def tick
      time = clock.tick
      generators.each { |generator| generator.generate(world, time) }
      agents.each { |agent| agent.act(world, time) }
      logger.log(world, time)
    end
    
    def agent(&block)
      self.agents << Actor.new(&block)
    end
    
    def generator(&block)
      self.generators << Generator.new(&block)
    end
    
    private
    
    class SimpleClock
      def initialize
        @ticks = -1
      end
      
      def tick
        @ticks += 1
      end
    end
    
    class Logger
      def log(object, time)
        puts "#{time}::: #{object.inspect}"
      end
    end
  end
end