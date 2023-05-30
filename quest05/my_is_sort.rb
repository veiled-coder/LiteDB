def my_is_sort(param_1)
return true if param_1.sort==param_1 || param_1.sort.reverse==param_1
return false

end
ans=my_is_sort([])
print ans