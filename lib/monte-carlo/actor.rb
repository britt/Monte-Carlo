module MonteCarlo
  class Actor
    attr_reader :name
    
    def initialize(name, &block)
      @name = name
      @action = block
    end
    
    def act(world)
      @action.call(world)
    end
  end
end