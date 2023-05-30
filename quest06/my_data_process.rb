require 'json'

def my_data_process(param_1)
  headerKeysArray= param_1.shift.split(",")
  headerHash=Hash[headerKeysArray.map do |key| [key,{}]end]

  param_1.each do |valueString|
  valueArray=valueString.split(",")
  

  headerKeysArray.each_with_index do |key,index|
  next if key == "FirstName" || key == "LastName" || key == "UserName" || key == "Coffee Quantity" 
  headerHash[key][valueArray[index]]||=0
  headerHash[key][valueArray[index]]+=1    


  end
  end
  headerHash.delete_if{|key,_|["FirstName","LastName","UserName","Coffee Quantity",].include?(key)}
  headerJson=JSON.generate(headerHash)
  puts headerJson
end

my_data_process(["Gender,FirstName,LastName,UserName,Email,Age,City,Device,Coffee Quantity,Order At", "Male,Carl,Wilderman,carl,yahoo.com,21->40,Seattle,Safari iPhone,2,afternoon", "Male,Marvin,Lind,marvin,hotmail.com,66->99,Detroit,Chrome Android,2,afternoon", "Female,Shanelle,Marquardt,shanelle,hotmail.com,21->40,Las Vegas,Chrome,1,afternoon", "Female,Lavonne,Romaguera,lavonne,yahoo.com,66->99,Seattle,Chrome,2,morning", "Male,Derick,McLaughlin,derick,hotmail.com,41->65,Chicago,Chrome Android,1,afternoon"])



















# input =["Gender,FirstName,LastName,UserName,Email,Age,City,Device,Coffee Quantity,Order At", "Male,Carl,Wilderman,carl,yahoo.com,21->40,Seattle,Safari iPhone,2,afternoon", "Male,Marvin,Lind,marvin,hotmail.com,66->99,Detroit,Chrome Android,2,afternoon", "Female,Shanelle,Marquardt,shanelle,hotmail.com,21->40,Las Vegas,Chrome,1,afternoon", "Female,Lavonne,Romaguera,lavonne,yahoo.com,66->99,Seattle,Chrome,2,morning", "Male,Derick,McLaughlin,derick,hotmail.com,41->65,Chicago,Chrome Android,1,afternoon"]
# # get first element of the input array which is a string
# def my_data_process(input)
# header=input.shift
# #convert to an array

# header_array=header.split(",")
# #puts header_array.inspect
# #["Gender", "FirstName", "LastName", "UserName", "Email", "Age", 
# #"City", "Device", "Coffee Quantity", "Order At"]

# #define hash with header_array as keys with {} values

# header_hash=Hash[header_array.map do |headkey| [headkey,{}] end]

# # puts header_hash

# #RESULT======={"Gender"=>{}, "FirstName"=>{}, "LastName"=>{}, "UserName"=>{}, 
# #"Email"=>{}, "Age"=>{}, "City"=>{}, "Device"=>{}, "Coffee Quantity"=>{}, "Order At"=>{}}

# #.................................DEALING WITH REMAINING INPUT VALUES........................INPUT IS STILL AN ARRAY OF STRINGS......
# #["Male,Carl,Wilderman,carl,yahoo.com,21->40,Seattle,Safari iPhone,2,afternoon", "Male,Marvin,Lind,marvin,hotmail.com,66->99,Detroit,Chrome Android,2,afternoon", "Female,Shanelle,Marquardt,shanelle,hotmail.com,21->40,Las Vegas,Chrome,1,afternoon", "Female,Lavonne,Romaguera,lavonne,yahoo.com,66->99,
# #Seattle,Chrome,2,morning", "Male,Derick,McLaughlin,derick,hotmail.com,41->65,Chicago,Chrome Android,1,afternoon"]
# #iterate through each remaining input element

# input.each do |individual_input_array_string|
    
# #puts individual_input_array_string.inspect #they are no more enclosed in an array,they are individual strings
# #"Male,Carl,Wilderman,carl,yahoo.com,21->40,Seattle,Safari iPhone,2,afternoon"
# #"Male,Marvin,Lind,marvin,hotmail.com,66->99,Detroit,Chrome Android,2,afternoon"
# #"Female,Shanelle,Marquardt,shanelle,hotmail.com,21->40,Las Vegas,Chrome,1,afternoon"
# #"Female,Lavonne,Romaguera,lavonne,yahoo.com,66->99,Seattle,Chrome,2,morning"
# #"Male,Derick,McLaughlin,derick,hotmail.com,41->65,Chicago,Chrome Android,1,afternoon"

# #CONVERT EACH STRING TO AN ARRAY
# array_formed_by_each_string=individual_input_array_string.split(",")
# # puts array_formed_by_each_string
# #["Male", "Carl", "Wilderman", "carl", "yahoo.com", "21->40", "Seattle", "Safari iPhone", "2", "afternoon"]
# #["Male", "Marvin", "Lind", "marvin", "hotmail.com", "66->99", "Detroit", "Chrome Android", "2", "afternoon"]
# #["Female", "Shanelle", "Marquardt", "shanelle", "hotmail.com", "21->40", "Las Vegas", "Chrome", "1", "afternoon"]
# #["Female", "Lavonne", "Romaguera", "lavonne", "yahoo.com", "66->99", "Seattle", "Chrome", "2", "morning"]
# #["Male", "Derick", "McLaughlin", "derick", "hotmail.com", "41->65", "Chicago", "Chrome Android", "1", "afternoon"]

# #..........GOING BACK TO  OUR HEADER ARRAY,LET'S LOOP THROUGH IT
# #["Gender", "FirstName", "LastName", "UserName", "Email", "Age", "City", "Device", "Coffee Quantity", "Order At"]
# header_array.each_with_index do |each_element_in_header_array,index_of_each_element_in_header_array|

# next  if each_element_in_header_array =="FirstName"||each_element_in_header_array =="LastName"|| each_element_in_header_array =="UserName" ||each_element_in_header_array == "Coffee Quantity" 
# each_element_in_array_formed_by_each_string=array_formed_by_each_string[index_of_each_element_in_header_array]  
# #note:both array_formed_by_each_string and header_array have same length so we can access all elements of array_formed_by_each_string
# #with index 0-9 as their length is 10
# #puts each_element_in_array_formed_by_each_string.inspect
# =begin 
# the horizontal ans is from the parent loop of input produing individual_input_array_string
# "Male,Carl,Wilderman,carl,yahoo.com,21->40,Seattle,Safari iPhone,2,afternoon"
# "Male"
# "Carl"
# "Wilderman"
# "carl"
# "yahoo.com"
# "21->40"
# "Seattle"
# "Safari iPhone"
# "2"
# "afternoon"
# "Male,Marvin,Lind,marvin,hotmail.com,66->99,Detroit,Chrome Android,2,afternoon"
# "Male"
# "Marvin"
# "Lind"
# "marvin"
# "hotmail.com"
# "66->99"
# "Detroit"
# "Chrome Android"
# "2"
# "afternoon"
# "Female,Shanelle,Marquardt,shanelle,hotmail.com,21->40,Las Vegas,Chrome,1,afternoon"
# "Female"
# "Shanelle"
# "Marquardt"
# "shanelle"
# "hotmail.com"
# "21->40"
# "Las Vegas"
# "Chrome"
# "1"
# "afternoon"
# "Female,Lavonne,Romaguera,lavonne,yahoo.com,66->99,Seattle,Chrome,2,morning"
# "Female"
# "Lavonne"
# "Romaguera"
# "lavonne"
# "yahoo.com"
# "66->99"
# "Seattle"
# "Chrome"
# "2"
# "morning"
# "Male,Derick,McLaughlin,derick,hotmail.com,41->65,Chicago,Chrome Android,1,afternoon"
# "Male"
# "Derick"
# "McLaughlin"
# "derick"
# "hotmail.com"
# "41->65"
# "Chicago"
# "Chrome Android"
# "1"
# "afternoon"
# =end


# #........BACK TO OUR HEADER HASH..............

# # puts header_hash

# #after parent loop run (10) 1 time,input prints out each long string,string converted to array,then the inner loop
# #runs 10 times to print all the long string elements,in this inner loop,we decided to print our header_hash,so 
# #after 1 iteration of the 10 inner loop iteration,our header_hash will be printed,tilll inner loop finissh its 10 times looping

# header_hash[each_element_in_header_array][each_element_in_array_formed_by_each_string]||=0
# header_hash[each_element_in_header_array][each_element_in_array_formed_by_each_string]+=1

# # puts header_hash
# #header_hash[headKey] to access or assign  value to the key

# #RESULT======={"Gender"=>{}, "FirstName"=>{}, "LastName"=>{}, "UserName"=>{}, 
# #"Email"=>{}, "Age"=>{}, "City"=>{}, "Device"=>{}, "Coffee Quantity"=>{}, "Order At"=>{}}

# end

# end
# puts JSON.generate(header_hash)

# end


# my_data_process(input)


# #END EXPECTED FINAL RESULT {"Gender":{"Male":3,"Female":2},"Email":{"yahoo.com":2,"hotmail.com":3},"Age":{"21->40":2,"66->99":2,"41->65":1},
# #"City":{"Seattle":2,"Detroit":1,"Las Vegas":1,"Chicago":1},"Device":{"Safari iPhone":1,"Chrome Android":2,"Chrome":2},"Order At":{"afternoon":4,"morning":1}}
