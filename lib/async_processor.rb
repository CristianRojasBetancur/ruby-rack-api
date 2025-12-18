require 'async'

class AsyncProcessor
  def self.call(delay, &block)
    Async do |task|
      task.sleep delay
      block.call
    end
  end
end
