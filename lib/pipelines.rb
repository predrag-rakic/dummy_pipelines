require "pipelines/version"
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

  class Exec
    def initialize(actions)
      @cmd=actions.select {|a| a.key? "cmd"}.first["cmd"]
      # puts @cmd
      @results = []
    end
    def cmd
      @cmd
    end
    def run
      @cmd.each {|c|
        begin
          @results << [%x[#{c}], $?.exitstatus]
          break if $?.exitstatus != 0
        rescue => e
          @results << [e, $?.exitstatus]
          break
        end
      }
      @results
    end
    def results
      @results
    end
  end

  class Pipeline
    def initialize(actions)
      @build   = Exec.new(actions["build"])
      deploys  = actions.select {|a,b| a != "build"}
      @deploys = deploys.map {|key, value| Exec.new(value)}
    end

    def run
      puts @build.cmd.inspect
      puts @build.run
      puts "!!!!!!!!!!!!!!!"
      @deploys.map {|deploy|
        puts "????????????"
        puts deploy.cmd.inspect
        puts deploy.run
      }
    end
  end
end

a = Pipelines.parse_
e = Pipelines::Pipeline.new a
e.run
