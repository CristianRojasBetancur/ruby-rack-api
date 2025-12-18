class MemoryStore
  def initialize
    @data = {}
    @mutex = Mutex.new
  end

  def write(id, object)
    @mutex.synchronize { @data[id] = object }
  end

  def find(id)
    @mutex.synchronize { @data[id] }
  end

  def all
    @mutex.synchronize { @data.values }
  end

  def delete(id)
    @mutex.synchronize { @data.delete(id) }
  end

  def clear!
    @mutex.synchronize { @data.clear }
  end
end
