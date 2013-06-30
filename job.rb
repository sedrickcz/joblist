#job.rb

class Job
  attr_accessor :name, :depends, :error
  def initialize parsed_string
    @name, @depends = parsed_string.split('=>')
    @error = ""
  end


  # Job is valid if name is present and job not depends on self
  # It sets @error with proper message
  def valid?
    @error = "Job can't depend on self" if @name == @depends
    @error = "Wrong format of input string" if @name.nil?
    @error.empty?
  end
end