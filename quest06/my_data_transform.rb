
require 'date'

def transformDate(dateTime,my_array)
   formattedDate=DateTime.parse(dateTime)
   hour= formattedDate.hour

   if (hour>=6 && hour<=12)
   my_array[-1]='morning'
  
   elsif (hour>=12&&hour<=18)
   my_array[-1]='afternoon'
  
   else 
   my_array[-1]='night'
 
   end
end
def transformAge(age,my_array)
if(age>=1 && age <=20)
   my_array[5]="1->20"
 elsif(age>=21 && age <=40)
   my_array[5]="21->40"
 elsif(age>=41 && age <=65)
   my_array[5]="41->65"
 elsif(age>=66 && age <=99)
   my_array[5]="66->99"

 end
end

def my_data_transform(param_1)

param_1_splitted= param_1.split("\n")
header=param_1_splitted.shift()#header is a string
output_array=[]
param_1_splitted.each_with_index do |value,i| 
  #    get dateTime  
  each_value_array= value.split(",")
  dateTime=each_value_array.last
  transformDate(dateTime,each_value_array)
 #get Age
 age=each_value_array[5].to_i
 transformAge(age,each_value_array)

 #get email
email=each_value_array[4].split("@")[1]
each_value_array[4]=email

#push ur changes
  each_string=each_value_array.join(",")
  output_array<<each_string

end
final_array=output_array.unshift(header)
p final_array
end

# my_data_transform("gender,firstName,city,order at\nMale,Rahma,Lagos,2020-03-06 6:37:56\nfemale,aisha,Abuja,2020-03-06 16:37:56\n")
my_data_transform("Gender,FirstName,LastName,UserName,Email,Age,City,Device,Coffee Quantity,Order At\nMale,Carl,Wilderman,carl,wilderman_carl@yahoo.com,29,Seattle,Safari iPhone,2,2020-03-06 16:37:56\nMale,Marvin,Lind,marvin,marvin_lind@hotmail.com,77,Detroit,Chrome Android,2,2020-03-02 13:55:51\nFemale,Shanelle,Marquardt,shanelle,marquardt.shanelle@hotmail.com,21,Las Vegas,Chrome,1,2020-03-05 17:53:05\nFemale,Lavonne,Romaguera,lavonne,romaguera.lavonne@yahoo.com,81,Seattle,Chrome,2,2020-03-04 10:33:53\nMale,Derick,McLaughlin,derick,mclaughlin.derick@hotmail.com,47,Chicago,Chrome Android,1,2020-03-05 15:19:48\n")

#my output ["Gender,FirstName,LastName,UserName,Email,Age,City,Device,Coffee Quantity,Order At", "Male,Carl,Wilderman,carl,yahoo.com,21->40,Seattle,Safari iPhone,2,afternoon", "Male,Marvin,Lind,marvin,hotmail.com,66->99,Detroit,Chrome Android,2,afternoon", "Female,Shanelle,Marquardt,shanelle,hotmail.com,21->40,Las Vegas,Chrome,1,afternoon", "Female,Lavonne,Romaguera,lavonne,yahoo.com,66->99,Seattle,Chrome,2,morning", "Male,Derick,McLaughlin,derick,hotmail.com,41->65,Chicago,Chrome Android,1,afternoon"]
#expected  ["Gender,FirstName,LastName,UserName,Email,Age,City,Device,Coffee Quantity,Order At", "Male,Carl,Wilderman,carl,yahoo.com,21->40,Seattle,Safari iPhone,2,afternoon", "Male,Marvin,Lind,marvin,hotmail.com,66->99,Detroit,Chrome Android,2,afternoon", "Female,Shanelle,Marquardt,shanelle,hotmail.com,21->40,Las Vegas,Chrome,1,afternoon", "Female,Lavonne,Romaguera,lavonne,yahoo.com,66->99,Seattle,Chrome,2,morning", "Male,Derick,McLaughlin,derick,hotmail.com,41->65,Chicago,Chrome Android,1,afternoon"]