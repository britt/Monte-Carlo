# An occurrence in the simulation world

module MonteCarlo
  class Event
    attr_accessor :label, :value, :creator, :timestamp
    
    def initialize(label, value, creator, timestamp)
      self.label = label
      self.value = value
      self.creator = creator
      self.timestamp = timestamp
    end
  end
end