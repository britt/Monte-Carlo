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
        
    it "should have a logger" do
      @simulator.should respond_to(:logger)
    end
  end
    
  describe "intialization" do    
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
      @generator.should_receive(:generate).once.with(@world)
      @agent.stub!(:act)
      @world.stub!(:tick)
      @world.stub!(:current_state)
      
      @simulator.tick
    end
    
    it "revises metrics"
    
    it "executes agent behaviors" do
      @generator.stub!(:generate)
      @agent.should_receive(:act).once.with(@world)
      @world.stub!(:tick)
      @world.stub!(:current_state)
      
      @simulator.tick
    end
    
    it "record results" do
      @generator.stub!(:generate)
      @agent.stub!(:act)
      @world.stub!(:tick)
      @world.should_receive(:current_state).once.and_return('current state')
      
      logger = mock('expectant logger')
      logger.should_receive(:log).once.with('current state')
      @simulator.logger = logger
      @simulator.tick
    end
    
    it "should move the clock forward one step" do
      @generator.stub!(:generate)
      @agent.stub!(:act)
      @world.should_receive(:tick)
      @world.stub!(:current_state)
      
      @simulator.tick
    end
  end
  
  describe "creating an agent" do
    before(:each) do
      @world = mock('simulation world')
      @simulator = MonteCarlo::Simulator.new(@world)
      @simulator.logger.stub!(:log)
    end
    
    it "should add create an agent and add it to the collection of agents for the simulation" do
      @simulator.agents.should be_empty
      @simulator.agent('An agent') { |world, time| true }
      
      @simulator.agents.size.should == 1
      @simulator.agents.first.should be_a_kind_of(MonteCarlo::Actor)
    end
  end
  
  describe "creating a generator" do
    before(:each) do
      @world = mock('simulation world')
      @simulator = MonteCarlo::Simulator.new(@world)
      @simulator.logger.stub!(:log)
    end
    
    it "should add create an agent and add it to the collection of agents for the simulation" do
      @simulator.generators.should be_empty
      @simulator.generator('A Generator') { |world, time| true }
      
      @simulator.generators.size.should == 1
      @simulator.generators.first.should be_a_kind_of(MonteCarlo::Generator)
    end
  end
  
  describe "running a simulation" do
    before(:each) do
      @world = MonteCarlo::World.new
      @world.stub!(:current_state)
      @simulator = MonteCarlo::Simulator.new(@world)
      @simulator.logger.stub!(:log)
    end
    
    it "should log the simulation parameters when the run starts" do
      logger = mock('expectant logger')
      logger.should_receive(:log).once.with(@simulator).ordered
      logger.should_receive(:log).once.with({:end => 5}).ordered
      logger.should_receive(:log).with(nil).exactly(5).times
      @simulator.logger = logger
      
      @simulator.run(:end => 5)
    end
    
    it "should tick the clock until the end time given" do      
      @simulator.run(:end => 5)
      @world.current_time.should == 5
    end
  end
end
