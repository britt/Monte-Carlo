require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe MonteCarlo::Simulator do
  describe "members" do
    before(:each) { @simulator = MonteCarlo::Simulator.new(mock()) }
    
    it "should have a world" do
      @simulator.should respond_to(:world)
    end
    
    it "should have generators" do
      @simulator.should respond_to(:generators)
    end
    
    it "should have agents" do
      @simulator.should respond_to(:agents)
    end
    
    it "should have a clock" do
      @simulator.should respond_to(:clock)
    end
    
    it "should have a logger" do
      @simulator.should respond_to(:logger)
    end
  end
    
  describe "intialization" do
    it "should use a simple clock if none is specified" do
      MonteCarlo::Simulator.new(mock).clock.should be_a_kind_of(MonteCarlo::Simulator::SimpleClock)
    end
    
    it "should log to standard out if no logger is specified" do
      MonteCarlo::Simulator.new(mock).logger.should be_a_kind_of(MonteCarlo::Simulator::Logger)
    end
  end
    
  describe "advancing the simulation time one tick" do
    before(:each) do
      @generator = mock('generator of history')
      @agent = mock('simulation agent')
      @world = mock('simulation world')
      @simulator = MonteCarlo::Simulator.new(@world, [@generator], [@agent])
      @simulator.logger.stub!(:log)
    end
    
    it "generates events" do
      @generator.should_receive(:generate).once.with(@world, 0)
      @agent.stub!(:act)
      @simulator.tick
    end
    
    it "revises metrics" do
      pending
    end
    
    it "executes agent behaviors" do
      @generator.stub!(:generate)
      @agent.should_receive(:act).once.with(@world, 0)
      @simulator.tick
    end
    
    it "record results" do
      @generator.stub!(:generate)
      @agent.stub!(:act)
      logger = mock('expectant logger')
      logger.should_receive(:log).once.with(@world, 0)
      @simulator.logger = logger
      @simulator.tick
    end
    
    it "should move the clock forward one step" do
      @generator.stub!(:generate)
      @agent.stub!(:act)
      clock = mock('expectant clock')
      clock.should_receive(:tick).once
      @simulator.clock = clock
      @simulator.tick
    end
  end
end
