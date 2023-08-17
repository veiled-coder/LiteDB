require "csv"
class MySqliteRequest
attr_accessor :table_name, :table_data,:hashedDataB, :request, :columns ,:result_hash_array,:isWhere,:where_count,:isJoin,:column_on_db_a,:column_on_db_b,:filter_column, :filter_column_value
def initialize
@isWhere=false
@isJoin=false
@where_conditions=[]
end

def from (table) # expect(MySqliteRequest.new.from('database.csv')).to be_a(MySqliteRequest) 
@table_name=table
self
end

def self.from(table) #expect(MySqliteRequest.from('database.csv')).to be_a(MySqliteRequest) 
MySqliteRequest.new.from(table)
end

def select(*variable_columns)# * this converts our parametrs to an array
@request='select'
@columns=variable_columns
self
end

def where(column_name, value) # During the run() you will filter the result which match the value.
@where_conditions<<{column_name=> value}  
@isWhere=true
self
end

def join(column_on_db_a, filename_db_b, column_on_db_b)
    # Read filename_db_b table data
    @isJoin=true
    @hashedDataB = CSV.parse(File.read(filename_db_b), headers: true).map(&:to_h).take(200)
    @column_on_db_a=column_on_db_a
    @column_on_db_b=column_on_db_b
   
    self
end
  
  

def run
    @result_hash_array=[] 
    @joined_hash_array=[]
    @filtered_hash_array=[]
    
        
    #convert table data in CSV::Row to a HashedData
    if @request==='select' # select the columns  from the each table row and corresponding data
    @table_data=table_to_hashed(@table_name)
        table_data.each do |current_row|
            result_hash={}
            @all_conditions_met=true;

            process_row(current_row, result_hash, @result_hash_array, @columns)
        

            if @isWhere                
                @where_conditions.each do |current_condition| #all where condtions will run for the current table row before the process_row runs
                    current_condition.each do |key,value|   
                        if current_row[key] != value         
                                @all_conditions_met=false
                                break
                        end
                    end
                end
            process_row(current_row, result_hash, @filtered_hash_array, @columns)if @all_conditions_met
            end

    end #end of table loop
        puts @result_hash_array.inspect
        # @result_hash_array=@filtered_hash_array
        puts '...................filtered'
        puts @filtered_hash_array
    end #of request='select'
    
    # puts @filtered_hash_array.inspect

    # if @isJoin 
    #     @result_hash_array.each do |rowA|
    #     @hashedDataB.each do |rowB|
    #       if rowB[@column_on_db_b] == rowA[@column_on_db_a]
    #         merged = rowA.merge(rowB)
    #         @joined_hash_array<<merged
    #       end
    #     end
    #   end  
    #    @result_hash_array=@joined_hash_array
    # end     
     
# puts @result_hash_array.inspect 
end#of def run
end#of class

#HELPER FUNCTIONS

def table_to_hashed(table_name)
hashedData=CSV.parse(File.read(table_name),headers:true).map(&:to_h).take(3)
return hashedData
end

def process_row(row,result_hash, result_hash_array,columns)
    if  columns[0]==='*'
        result_hash_array<<row
   
    else
        columns.each do |column_name| 
        result_hash[column_name]=row[column_name]

        end
    end  
    result_hash_array << result_hash if result_hash != {}
end

# request = MySqliteRequest.new
# request = request.from('nba_player_data.csv')
# request = request.select('name')
# request.run

# request = MySqliteRequest.new
# request = request.from('nba_player_data.csv')
# request = request.select('name','college')
# request = request.where('college', 'University of California')
# request.run

request = MySqliteRequest.new
request = request.from('nba_player_data.csv')
request = request.select('name','year_start','college')
request = request.where('college', 'University of California')
# request = request.where('year_start', '1997')
# request =request.join('college','nba_players.csv','college')
request.run