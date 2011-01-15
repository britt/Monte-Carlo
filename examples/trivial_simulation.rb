$: << File.dirname(__FILE__) + '/../lib'
require 'monte-carlo'

simulation = MonteCarlo::Simulator.new(MonteCarlo::World.new)
simulation.agent('even') do |world|
  world.add_event('Even Time!','Oh yeah!', 'even') if world.current_time % 2 == 0
end

20.times do 
  simulation.tick
end

puts simulation.world.history.inspect