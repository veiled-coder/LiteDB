def my_count_on_it(param_1)
my_array=[]
param_1.each do |param|
  my_array.push(param.length)
end
return my_array
end
ans=my_count_on_it(["abc","rfgtt"])
print ans