
require_relative 'my_sqlite_request'

class MySQLite
    def initialize
    puts "MySQLite version 0.1 #{Time.now.strftime('%Y-%m-%d')}"
    queryUserInput
    end
end    

#SELECT * FROM students.db
def queryUserInput
loop do
    print 'my_sqlite_cli>'
    query=gets.chomp
    result=''
case query

when 'exit'
    puts 'exiting sqlte cli'
    break
when /^(\s*(SELECT|select)\s+([\w\s*,]+)\s+(FROM|from)\s+(\S+)\s*(?:(WHERE|where)\s+(.*?))?\s*)$/

    column_name=$3
    table_name="#{$5}.csv"
    where_conditions=$7
    result=runSelectQuery(table_name,column_name).run
       
    if where_conditions
    result=runSelectWhereQuery(where_conditions,table_name,column_name).run      
    end
   
    

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
        columNameArray=column_name.split(",")   #was "name,age" now ['name','age']
        request = request.select(*columNameArray)
    end
    return request
end

def runSelectWhereQuery(conditions,table_name,column_name)
    request=runSelectQuery(table_name,column_name)
    splitted_conditions=conditions.split(",")#["name=Ivica Zubac", "year_start=1949"]   
    splitted_conditions.each do |current_condition|
        current_pair_array=current_condition.split("=")
        request=request.where(*current_pair_array)
    end
    return request
end

MySQLite.new
# select name,age from nba_player_data.csv