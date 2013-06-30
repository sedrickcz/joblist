#job_list.rb

class JobList
  attr_accessor :jobs, :error, :ordered_jobs

  def initialize jobs_string
    @error = ""
    @stack_counter = 0
    @ordered_jobs = []
    @jobs = parse_jobs_field(jobs_string)
  end

  #Return array of Job objects
  def parse_jobs_field jobs_string
    jobs_array = [] 
    jobs_string.split('|').each do |job|
      new_job = Job.new(job)
      jobs_array << new_job if job_is_valid?(new_job)
    end
    jobs_array
  end

  #Check if Job is valid and return true/false and if false then set @error from Job.error
  def job_is_valid? job
    @error = job.error if !job.valid?
    job.valid?
  end

  # Iterate over jobs and reorder by dependencies. It set ordered_jobs with ordered array of jobs for an output
  def order_jobs_by_dependings
    @jobs.each do |job|
      @ordered_jobs += reorder(job).reverse! if !@ordered_jobs.include?(job.name)
    end
  end

  # Reorder jobs by dependencies by recursion
  # Returns empty array if stack is too deep - circular dependencies or
  # array of self name if there are no dependencies or
  # array of ordered dependable jobs 
  def reorder job
    return [] if !job_exists?(job) or stack_too_deep?
    dependencies_array = [job.name]
    return dependencies_array if job.depends.nil?
    dependencies_array += reorder(fetch_dependable_job(job.depends)) if !@ordered_jobs.include?(job.depends)
    dependencies_array
  end

  # Fetch dependable object for deeper reorder
  # Returns Job object or nil
  def fetch_dependable_job job_name
    jobs.select{|j| j.name == job_name}.first    
  end

  # Return ordered jobs or error message to output
  def show
    order_jobs_by_dependings
    unless @error.empty?
      return "Error: #{@error}"
    else
      return sequence
    end
  end

  # Checking if is stack too deep? If it's deeper than number of jobs, sets a error and return true
  # else return false
  def stack_too_deep?
    @stack_counter += 1
    if @stack_counter > @jobs.size
      @error = "Jobs can't have circular dependencies!"
      return true
    end
    false
  end

  # Checking if Job or its dependency exists
  # set error and return false if not exists
  # return true if exists
  def job_exists? job
    if job.nil?
      @error = "Dependency to non exsting job!"
      return false
    end
    true
  end

  # Return sequence of jobs or if is empty it returns "No jobs" messages
  def sequence
    if @ordered_jobs.empty?
      "No jobs"
    else
      @ordered_jobs.join(' -> ')
    end
  end
end