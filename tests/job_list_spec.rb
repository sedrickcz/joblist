#job_list_spec.rb

require '../job_list'
require '../job'

describe JobList do
  it 'should return empty string if jobs are empty string' do
    list = JobList.new("")
    list.jobs.should eq([])
  end

  it 'should return field of Job objects' do
    list = JobList.new("a=>|b=>|c=>")
    list.parse_jobs_field("a=>|b=>|c=>").size.should eq(3)
  end

  it 'should return empty array if input string is empty' do
    list = JobList.new("")
    list.parse_jobs_field("").size.should eq(0)
  end

  it 'should return error message if Job is not valid' do
    list = JobList.new("a=>a|b=>|c=>")
    job = list.jobs.first
    list.job_is_valid?(job)
    list.error.should_not be_empty 
  end

  it 'should return right ordered jobs' do
    list = JobList.new("a=>|b=>c|c=>")
    list.order_jobs_by_dependings
    list.ordered_jobs.join(' -> ').should eq('a -> c -> b')
  end

  it 'should return ordered array by dependencies' do
    list = JobList.new("a=>|b=>c|c=>")
    list.reorder(list.jobs[1]).reverse!.should eq(['c','b'])
  end

  it 'should return array of job name if no depndencies' do
    list = JobList.new("a=>|b=>|c=>")
    list.reorder(list.jobs[1]).should eq(['b'])
  end 

  it 'should return dependable Job' do
    list = JobList.new("a=>|b=>c|c=>")
    dependable_job = 'c'
    list.fetch_dependable_job(dependable_job).name.should eq('c')
  end

  it 'should return error message if circular dependencies' do
    list = JobList.new("a=>|b=>c|c=>f|d=>a|e=>|f=>b")
    list.order_jobs_by_dependings
    list.error.should eq("Jobs can't have circular dependencies!")
  end

  it 'should puts error message if any error' do 
    list = JobList.new("a=>|b=>c|c=>f|d=>a|e=>|f=>b")
    list.show.should match(/Error:.*/)
  end

  it 'should return error message if job dependency not exists' do
    list = JobList.new("a=>|b=>|c=>x")
    list.order_jobs_by_dependings
    list.error.should eq("Dependency to non exsting job!")
  end

end