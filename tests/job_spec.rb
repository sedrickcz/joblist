#job_spec.rb

require '../job'

describe Job do
  it 'should not be valid if name is empty' do
    job = Job.new("")
    job.valid?.should be_false
  end

  it 'should retun error message if name is empty' do
    job = Job.new("")
    job.valid?
    job.error.should eq("Wrong format of input string")
  end

  it 'should be valid if name is present' do
    job = Job.new("a=>")
    job.valid?.should be_true
  end

  it 'should not be valid if name is equal depends' do
    job = Job.new("a=>a")
    job.valid?.should be_false
  end

  it 'should retun error message if name is equal depends' do
    job = Job.new("a=>a")
    job.valid?
    job.error.should eq("Job can't depend on self")
  end

  it 'should have depends set if string \'a=>b\'' do
    job = Job.new("a=>b")
    job.depends.should eq("b")
  end
end