require_relative 'my_sqlite_request'

class MySQLite
    def initialize
    puts "MySQLite version 0.1 #{Time.now.strftime('%Y-%m-%d')}"
    queryUserInput
    end
end    

def queryUserInput
loop do
    print 'my_sqlite_cli>'
    query=gets.chomp
    result=''
case query

when 'exit'
    puts 'exiting sqlte cli'
    break
when /^(\s*(SELECT|select)\s+([\w\s*,]+)\s+(FROM|from)\s+(\S+)\s*(?:(JOIN|join)\s+(\S+)\s+(on|ON)\s+(\S+))?(?:(WHERE|where)\s+(.*?))?\s*)$/
    column_name=$3
    table_name="#{$5}.csv"
    where_conditions=$11
    table_name2="#{$7}.csv"
    join_on=$9 

    result=runSelectQuery(table_name,column_name).run
    if join_on
        result=runJoinQuery(join_on,table_name,table_name2,column_name).run
    end
    if where_conditions
        result=runSelectWhereQuery(where_conditions,table_name,column_name).run      
    end

when /^(?:INSERT|insert)\s+(?:INTO|into)\s+(\w+)(?:\s+\(([^)]+)\))?\s+(?:VALUES|values)\s+\(([^)]+)\)\s*;?\s*$/

     table_name="#{$1}.csv"
     table_column=$2
     table_data=$3
     hash_data_array=[]
     parsed_table_data = CSV.parse(table_data).first
     runInsertQuery(table_name,table_column,hash_data_array,parsed_table_data).run

when /(?:UPDATE|update)\s+(\w+)\s+(?:SET|set)\s+(.+?)\s+(?:WHERE|where)\s+(.+)/

    table_name="#{$1}.csv"
    values=$2
    where_conditions=$3
    request=runUpdateQuery(table_name,values,where_conditions).run
   


else
    puts 'Invalid query format. Please enter a valid query...e.g..SELECT * FROM database.csv'  
end#when
puts result.inspect
# return result
end#loop
end#defQuery

# #HELPER FUNCTIONS

    

def runSelectQuery(table_name,column_name)
    request = MySqliteRequest.new
    request = request.from(table_name)
    if column_name=="*"
        request = request.select(column_name)
    else
        columNameArray=column_name.split(",")  
        request = request.select(*columNameArray)
    end
    return request
end

def runSelectWhereQuery(conditions,table_name,column_name)
    request=runSelectQuery(table_name,column_name)
    splitted_conditions=conditions.split(",") 
    
    splitted_conditions.each do |current_condition|
        current_pair_array=current_condition.split("=")

        condition_array=current_pair_array.map do |condition|
            condition.delete_prefix("'").delete_suffix("'")
        end
        request=request.where(*condition_array)
    end
    return request
end

def runJoinQuery(join_conditions,table_name,table_name2,column_name)
    join_conditions_array=join_conditions.split("=")
    request=runSelectQuery(table_name,column_name)
    request=request.join(join_conditions_array[0],table_name2,join_conditions_array[1])
    return request
end

def runInsertQuery(table_name,table_column,hash_data_array,parsed_table_data)
if table_column
        split_column=table_column.split(",")
        split_column.each_with_index do |column,i|
        data_hash={}
        data_hash[column] = parsed_table_data[i]
        hash_data_array<<data_hash
        end
        
 end

 
request = MySqliteRequest.new
request = request.insert(table_name)
    if table_column
        request = request.values(*hash_data_array)
        else
        request = request.values(*split_data)
    end
request
end
def runUpdateQuery(table_name,values,where_conditions)
    splitted_values=values.split(", ")
    values_to_update={}
   
    splitted_values.each do |value_pair|
        value_pair_hash={}
        #create an hash for eaac pair,then push to an array
        value_pair_array=value_pair.split("=")
        edited_pair_array=value_pair_array.map do |element|
            element.strip
        end
     
        value_pair_hash[edited_pair_array[0]]=edited_pair_array[1]
        values_to_update.merge!(value_pair_hash)
    end
   

request = MySqliteRequest.new
request = request.update(table_name)
request = request.values(values_to_update)
request = processWhereConditions(where_conditions,request)
request
end

def processWhereConditions(conditions,request)
    splitted_conditions=conditions.split(",")

    splitted_conditions.each do |current_condition|
        current_pair_array=current_condition.split("=")
        edited_pair_array=current_pair_array.map do |element|
            element.strip
     end
        request=request.where(*edited_pair_array)
    end
    return request
end
MySQLite.new
# UPDATE nba_player_data SET name = 'Bill Renamed', year_start = '2330' WHERE name = 'Bill Zopf',year_start='1971'

# request = MySqliteRequest.new
# request = request.update('nba_player_data.csv')
# request = request.values('name' => 'Alaa Renamed2','year_start'=>'2023')
# request = request.where('name', 'Alaa Renamed')
# request = request.where('year_start', '1991')

# the values were received as [{"name"=>"Alaa Renamed2", "year_start"=>"2023"}]

# INSERT INTO nba_player_data (name,year_start,year_end,position,height,weight,birth_date,college) VALUES (Alaa Abdelnaby34,1991,1995,F-C,6-10,240,"June 24, 1968",Duke University)


#as a hash data is sent this way 
#'name' => 'Alaa Abdelnaby', 'year_start' => '1991', 'year_end' => '1995', 'position' => 'F-C', 'height' => '6-10', 'weight' => '240', 'birth_date' => "June 24, 1968", 'college' => 'Duke University'    






# SELECT name
# FROM table1
# JOIN table2 ON  table1.id=table2.id
#SELECT name,email FROM students WHERE name='Matt Zunic'

# request = MySqliteRequest.new
# request = request.from('nba_player_data.csv')
# request=request.select('*')
# request=request.join('weight','nba_players.csv','weight2')
# request.run

# UPDATE students SET email = 'jane@janedoe.com', blog = 'https://blog.janedoe.com' WHERE name = 'Mila'
