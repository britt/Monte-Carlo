module MonteCarlo
  class Actor
    attr_reader :name
    
    def initialize(name, &block)
      @name = name
      @action = block
    end
    
    def act(world, time)
      @action.call(world, time)
    end
  end
end