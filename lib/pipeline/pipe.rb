module Pipeline
  class Pipe
    def initialize(message = {})
      @message = message
      @stage = []
    end

    def stage(stage)
      @stage.push(stage)
    end

    def executa
      @stage.each do |stage|
          puts "stage: #{stage.class} message: #{@message.inspect}"
          @message = stage.executa(@message)
      end
      @message
    end
  end
end