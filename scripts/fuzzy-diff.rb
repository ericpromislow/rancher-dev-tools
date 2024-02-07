#!/usr/bin/env ruby

if ARGV.size != 2
  abort "Usage: #{File.basename($0)} file1 file2"
end

file1 = ARGV[0]
file2 = ARGV[1]

lines1 = IO.readlines(file1).map(&:chomp).reject {|x| x.end_with?('.tar.gz') }
lines2 = IO.readlines(file2).map(&:chomp).reject {|x| x.end_with?('.tar.gz') }

ix = iy = 0
exitStatus = 0
while ix < lines1.size && iy < lines2.size
  line1 = lines1[ix]
  line2 = lines2[iy]
  parts1 = line1.split(':')
  parts2 = line2.split(':')
  case parts1[0] <=> parts2[0]
  when -1
    puts "R1: #{line1}"
    ix += 1
    exitStatus = 1
  when -1
    puts "R2: #{line2}"
    iy += 1
    exitStatus = 1
  else
    p1 = line1.split(/[-:._]/)
    p2 = line2.split(/[-:._]/)
    numDiffs = p1.zip(p2).reject { |a, b| a == b }.size
    if numDiffs == 0
      abort("Unexpected: 0 diffs for line1 #{line1} // line2 #{line2}")
    elsif numDiffs == 1
      puts "Similar lines:\n+ #{line1}\n+ #{line2}"
      ix += 1
      iy += 1
    else
      if line1 < line2
        puts "R1: #{line1}"
        ix += 1
        exitStatus = 1
      else
        puts "R2: #{line2}"
        iy += 1
        exitStatus = 1
      end
    end
  end
end

if ix < lines1.size
  puts lines1[ix..-1].map{|line| "R1: #{line}"}
  exitStatus = 1
elsif iy < lines1.size
  puts lines2[iy..-1].map{|line| "R2: #{line}"}
  exitStatus = 1
end
exit exitStatus
