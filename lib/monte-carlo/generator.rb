# A generator of history, generates external events that occur in the simulation world.

module MonteCarlo
  class Generator < Actor
    def generate(world)
      @action.call(world)
    end
  end
end