require "csv"
class MySqliteRequest
attr_accessor :table_name, :hashedDataA,:hashedDataB, :request,:filename_db_b, :columns ,:selected_hash_array,:isWhere,:where_count,:isJoin,:column_on_db_a,:column_on_db_b,:filter_column, :filter_column_value
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
   
    @column_on_db_a=column_on_db_a
    @column_on_db_b=column_on_db_b
    @filename_db_b=filename_db_b
   
    self
end
  
  

def run
    @hashedDataA=table_to_hashed(@table_name)
    @selected_hash_array=[] 
    @filtered_hash_array=[]
    @merged_hash_array=[]
    @final=[]
    
    
    if @isJoin
        @hashedDataB = CSV.parse(File.read(@filename_db_b), headers: true).map(&:to_h).take(5)    
        @hashedDataA.each do |rowA|
        result_hash={}
            @hashedDataB.each do |rowB|
                if rowB[@column_on_db_b] === rowA[@column_on_db_a]
                merged = rowA.merge(rowB)
                 @merged_hash_array<<merged
                end
            end
        end#hashsedDataA
        @hashedDataA=@merged_hash_array
    end#is join

       
    #convert table data in CSV::Row to a HashedData
    if @request==='select' # select the columns  from the each table row and corresponding data
        @hashedDataA.each do |current_row|
            result_hash={}
            @all_conditions_met=true;

            process_row(current_row, result_hash, @selected_hash_array, @columns)
            @final=@selected_hash_array
        

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
            @final=@filtered_hash_array
        end

    end #end of table loop
        
 end #of request='select'
    
    


puts '..........................final result'   
puts @final.inspect
end#of def run
end#of class

#HELPER FUNCTIONS

def table_to_hashed(table_name)
hashedData=CSV.parse(File.read(table_name),headers:true).map(&:to_h).take(5)
return hashedData
end

def process_row(row,result_hash, selected_hash_array,columns)
    if  columns[0]==='*'
        selected_hash_array<<row
   
    else
        columns.each do |column_name| 
        result_hash[column_name]=row[column_name]

        end
    end  
    selected_hash_array << result_hash if result_hash != {}
    
end


request = MySqliteRequest.new
request = request.from('nba_player_data.csv')
request = request.select("name",'weight','weight2','college','year_start','player')
request = request.where('college', 'University of California')
request = request.where('year_start', '1997')
# request =request.join('college','nba_players.csv','college')

request.run

 