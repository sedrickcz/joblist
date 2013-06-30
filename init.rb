#!/usr/bin/env ruby -wKU

# Require dependencies
require './job.rb'
require './job_list.rb'

# Get first argument with trim all spaces or set empty string
input = ARGV.first.gsub(/\s+/, "") || ""

# Init JobList with input 
job_list = JobList.new(input)
# Output => Sequence of jobs
puts job_list.show