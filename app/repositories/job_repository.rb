class JobRepository
  def initialize(store)
    @store = store
  end

  def add(job)
    @store.write(job.id, job)
  end

  def find(id)
    job = @store.find(id)
    return unless job

    job.expire! if job.expired?
    job
  end

  def delete(id)
    @store.delete(id)
  end
end
