class Testbotsy

  def initialize(config, &block)
    @patterns = []
    @running = true
    return if ENV['RSPEC_RUN'] == 'true'
    self.instance_exec([],&block)
    Thread.new do
      sleep 1
      run
    end
  end

  def hear(pattern, &block)
    @patterns << [pattern, block]
  end

  def run
    while @running
      STDERR.<< "\e[1;33m#{ENV['BOT_SHORT_NAME']} \e[1;31m♥︎\e[1;34m> \e[0m"
      line = gets
      if line =~ /^!!PRY/
        binding.pry
      else
        @patterns.each do |(p, block)|
          if mdata = p.match(line)
            result = block.call(mdata)
            puts "## Result: #{result.inspect}"
          end
        end
      end
    end
  end

  # These two methods ape some of Slackbotsy that Alice relies on
  def user_name
    "someone"
  end
  def user_id
    42
  end

end
