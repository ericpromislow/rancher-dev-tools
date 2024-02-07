lineBuf = []

ptnCDiff = /^\d+c\d+\s*$/
kuidPtn = /\s*"k:.*?uid.*?"[-0-9a-f]+.*?":\s*\{\}/

ptnTimeBefore = /^<#{kuidPtn}/
diffDashes = /^---\s*$/
ptnTimeAfter = /^>#{kuidPtn}/
emptyLine = /^\s*$/

state = 0
lineBuf = []

ARGF.each do |line|
  case line
  when emptyLine
    lineBuf << line
  when ptnCDiff
    if state == 0
      lineBuf = [line]
      state = 1
    else
      puts lineBuf.join('')
      puts line
      state = 0
      lineBuf = []
    end
  when ptnTimeBefore
    if state == 1
      state = 2
      lineBuf << line
    else
      puts lineBuf.join('')
      puts line
      state = 0
      lineBuf = []
    end
  when diffDashes
    if state == 2
      state = 3
      lineBuf << line
    else
      puts lineBuf.join('')
      puts line
      state = 0
      lineBuf = []
    end
  when ptnTimeAfter
    if state == 3
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
    end
    puts line
  end
end

    
  
