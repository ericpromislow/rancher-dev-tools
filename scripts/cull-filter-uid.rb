lineBuf = []

ptnADiff = /^\d+a\d+\s*$/
ptnTimeAfter = /^>\s+"filterUid":\s*".*?"/

state = 0

ARGF.each do |line|
  case line
  when ptnADiff
    if state == 0
      lineBuf = [line]
      state = 1
    else
      puts lineBuf.join('')
      puts line
      state = 0
      lineBuf = []
    end
  when ptnTimeAfter
    if state == 1
      state = 0
      lineBuf = []
    else
      puts lineBuf.join('')
      puts line
      state = 0
      lineBuf = []
    end
  else
    if state > 0
      puts lineBuf.join('')
      lineBuf = []
      state = 0
    end
    puts line
  end
end

puts lineBuf.join('')

    
  
