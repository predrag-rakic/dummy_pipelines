require "pipelines/version"
require "pipelines/exec"
require "psych"

module Pipelines
  # Your code goes here...

  def self.build
    Exec.new(parse_["build"])
  end
  def self.parse_
    parse("project/simple.yml")
  end
  def self.parse(file)
    project = Psych.load_file(file)
  end


  class Pipeline
    def initialize(actions)
      @build   = Exec.new(actions["build"], "build")
      deploys  = actions.select {|a,b| a != "build"}
      @deploys = deploys.map {|key, value| Exec.new(value, key)}
    end

    def run
      @build.run
      puts @build.show
      @deploys.map {|deploy|
        deploy.run
        puts deploy.show
      }
    end
  end
end

a = Pipelines.parse_
e = Pipelines::Pipeline.new a
e.run
