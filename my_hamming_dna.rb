def dna(param_1, param_2)
  count = 0
  
  if param_1.length != param_2.length
    return -1
  elsif param_1.empty? && param_2.empty?
    return 0
  else
   param_1.length.times do |val|
  p val
      if param_1[val] != param_2[val]
        count += 1
      end
    end
end


return count
      end


ans = dna("ACCAGGG" , "ACTATGG")
p ans
