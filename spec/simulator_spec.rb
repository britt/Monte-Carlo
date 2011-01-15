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
      
      @simulator.tick
    end
    
    it "revises metrics"
    
    it "executes agent behaviors" do
      @generator.stub!(:generate)
      @agent.should_receive(:act).once.with(@world)
      @world.stub!(:tick)
      
      @simulator.tick
    end
    
    it "record results" do
      @generator.stub!(:generate)
      @agent.stub!(:act)
      @world.stub!(:tick)
      logger = mock('expectant logger')
      logger.should_receive(:log).once.with(@world)
      @simulator.logger = logger
      @simulator.tick
    end
    
    it "should move the clock forward one step" do
      @generator.stub!(:generate)
      @agent.stub!(:act)
      @world.should_receive(:tick)
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
end
