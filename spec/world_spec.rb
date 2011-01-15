require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe MonteCarlo::World do
  describe "members" do
    before(:each) { @world = MonteCarlo::World.new }
    
    it "should have a clock" do
      @world.should respond_to(:clock)
    end
    
    it "should have current events" do
      @world.should respond_to(:current_events)
    end
    
    it "should have a history" do
      @world.should respond_to(:history)
    end
  end
  
  describe "initialization" do
    it "should use a simple clock if none is given" do
      MonteCarlo::World.new.clock.should be_a_kind_of(MonteCarlo::World::SimpleClock)
    end
  end
  
  describe "time" do
    it "the current time should be the clock time" do
      clock = mock('clock')
      clock.stub!(:time).and_return('And the simulation world was without form, and void; and darkness was upon the face of the deep.')
      MonteCarlo::World.new(clock).current_time.should == clock.time
    end
    
    context "before any ticks of the clock" do
      before(:each) { @world = MonteCarlo::World.new }
      
      it "there should be no current events" do
        @world.current_events.should be_empty
      end
      
      it "there should be no history" do
        @world.history.should be_empty
      end
    end
    
    context "after a tick of the clock" do
      before(:each) do
        @world = MonteCarlo::World.new
        @world.tick
      end
      
      it "formerly current events should now be in the past" do
        @world.add_event('an event', 0, 'me')
        time = @world.current_time
        @world.tick
        @world.current_events.should be_empty
        @world.history[time].first.label.should == 'an event'
      end
      
      it "the clock should move forward" do
        time = @world.current_time
        @world.tick
        @world.current_time.should > time
      end
    end
  end
  
  describe "adding an event" do
    before(:each) do
      @world = MonteCarlo::World.new
    end
    
    it "should add to current events" do
      @world.current_events.should be_empty
      @world.add_event('an event', 0, 'me')
      @world.current_events.should_not be_empty
    end
    
    it "should set the values of the event" do
      @world.add_event('an event', 0, 'me')
      event = @world.current_events.first
      event.label.should == 'an event'
      event.value.should == 0
      event.creator.should == 'me'
    end
    
    it "should timestamp the event" do
      @world.add_event('an event', 0, 'me')
      event = @world.current_events.first
      event.timestamp.should == @world.current_time
    end
  end
end
