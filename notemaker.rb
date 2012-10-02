#/bin/ruby

require 'Date'
require 'erb'

#Find .notes files, look for most recent file
f = Dir.glob("*.notes")
latest = Date.new(1900,1,1)
latestfile = "000000" #placeholder for latest date/filename


#loops through file and finds latestfile
f = f.select {|file| file.match(/^ \d{6} \.notes /x)}
f.each do |fname|
  next if fname.match(/template/)
  date_string = Date.strptime("#{fname}",'%m%d%y')
   if (latest-date_string<0)
     latest = date_string
     latestfile = fname
   end
end

puts latestfile

#Now parses latest file for things to carry over into todays notefile


lines = Hash.new
File.open(latestfile).each do |f|
section = 1 # 1=todo , 2=reminders , 3=notes
  f.each_line do |line|
    next if line.match(/^={12}$/)
    next if line.match(/^\* \s{1} To\-Do$ /x)
    if line.match(/^\* \s{1} Reminders$ /x)
      section = 2
    end 
    if line.match(/^\* \s{1} Notes$ /x)
      section = 3
    end
    
    next if line.match(/^\#/)
    lines["#{line}"] = section
  end
end

puts lines

# takes most recent file, copies variables
# parses them to erb
# outputs to new file
# prints new file name
