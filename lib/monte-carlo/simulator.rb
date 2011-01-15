# Runs the simulation and marks time.

module MonteCarlo
  class Simulator
    attr_accessor :agents, :generators, :world, :logger
    
    def initialize(world, generators = [], agents = [], opts = {})
      self.world = world
      self.agents = agents
      self.generators = generators
      self.logger = opts[:logger] || Logger.new
    end
    
    def run
    end
    
    def tick
      time = world.tick
      generators.each { |generator| generator.generate(world) }
      agents.each { |agent| agent.act(world) }
      logger.log(world)
    end
    
    def agent(name, &block)
      self.agents << Actor.new(name, &block)
    end
    
    def generator(name, &block)
      self.generators << Generator.new(name, &block)
    end
    
    private
    
    class Logger
      def log(object)
        puts object.inspect
      end
    end
  end
end