lineBuf = []

things = /(time|token|userId|migration-statusLastUpdated|lastUpdateTime|digest|uid)/
ptnCDiff = /^\d+c\d+\s*$/
ptnTimeBefore = /^<\s+"#{things}":\s*".*?"/
diffDashes = /^---\s*$/
ptnTimeAfter = /^>\s+"#{things}":\s*".*?"/

state = 0
lastThing = ""

ARGF.each do |line|
  case line
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
      lastThing = $1
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
    if state == 3 && lastThing == $1
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

    
  
