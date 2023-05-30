
def my_csv_parser(my_string,delimiter)

final_array=[]
splited=my_string.split("\n")
for i in 0...splited.length
  final_array.push(splited[i].split(delimiter))
end


print final_array
end

my_csv_parser("a,b,c,e\n1,2,3,4\n", ",")

