lineBuf = []

diffPtn = /^diff -r minio-files-release/

state = 0

ARGF.each do |line|
  case line
  when diffPtn
    if state == 0
      lineBuf = [line]
      state = 1
    elsif state == 1
      lineBuf = [line]
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

    
  
