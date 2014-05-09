require 'zeus/rails'

class CustomPlan < Zeus::Rails

  def spec(argv=ARGV)
    if argv.empty?
      exit RSpec::Core::Runner.run(['spec'])
    else
      exit RSpec::Core::Runner.run(argv)
    end
  end
end

Zeus.plan = CustomPlan.new
