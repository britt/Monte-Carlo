module MonteCarlo
  class Actor
    def initialize(&block)
      @action = block
    end
    
    def act(world, time)
      @action.call(world, time)
    end
  end
end