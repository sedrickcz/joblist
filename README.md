h1. joblist

h3. Create ordered sequence of jobs from string input

h2. Run

ruby init.rb [string_param]

"string_param" is string sequence of jobs where character before "=>" is name of a job and character after "=>" is a job dependecy. If it's empty it has no dependency. 
Jobs are separated by "|"

For example:

h3. Input
ruby init.rb "a=>|b=>|c=>"
h3. Output
a -> b -> c

h3. Input
ruby init.rb "a=>|b=>c|c=>"
h3. Output
a -> c -> b
