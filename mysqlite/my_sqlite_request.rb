require "csv"
class MySqliteRequest
attr_accessor :table_name, :headers,:hashedDataA,:dataToInsert,:hashedDataB, :request,:filename_db_b, :columns ,:isOrder, :order_type, :order_col,:selected_hash_array,:isWhere,:where_count,:isJoin,:column_on_db_a,:column_on_db_b,:filter_column, :filter_column_value
def initialize
@isWhere=false
@isJoin=false
@where_conditions=[]
@isOrder=false
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
  

def order(order, column_name)
    @isOrder = true
    @order_type = order
    @order_col = column_name
    self
  end

  
def insert(table_name)
  @table_name=table_name
  @request='insert'
  
  self 
end

def self.insert (table_name)
  MySqliteRequest.new.insert(table_name)
end

def values(*data) #a hash of data key => value
@dataToInsert=data
self
end

def run
      
   
    if File.exist?(table_name)
      @hashedDataA=table_to_hashed(@table_name)
      else
      @hashedData=create_csv_file(@table_name,@dataToInsert) if !File.exist?(table_name)
    end
    @selected_hash_array=[] 
    @filtered_hash_array=[]
    @merged_hash_array=[]
    @final=[]
    
    
    if @isJoin
        joined_tables=join_tables(@hashedDataB,@hashedDataA,@filename_db_b,@column_on_db_b,@column_on_db_a)
        @hashedDataA=joined_tables
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
                end #isWhere

                if @isOrder
                    sorted_hashes = if @order_type == 'asc'  
                      merge_sort(@final) { |a, b| a[order_col].downcase <=> b[@order_col].downcase }
                    elsif @order_type=='desc'
                      merge_sort(@final) { |a, b| b[order_col].downcase <=> a[@order_col].downcase }
                    end
                @final=sorted_hashes
                end#isOrder
        end #end of table loop
        
    end #of request='select'
    
    if @request=='insert' #dear reviewer, i dont know why these brings error in this ide,kindly
      insert_row(@table_name,@dataToInsert)
    end #of request='insert'
  
 

puts '..........................final result'   
puts @final.inspect
end#of def run
end#of class

#HELPER FUNCTIONS

def create_csv_file(table_name,dataToInsert)
    CSV.open(table_name,"w") do |csv|
      #extract the headers from the @dataToInsert 
     dataToInsert.each do |data|
      headers= data.map do |key,value| #get the key names as headers into an array,map returns anarray
         key
      end
      csv<<headers
      end
    end
    table_to_hashed(table_name)
end 

def table_to_hashed(table_name)
  hashedData=CSV.parse(File.read(table_name),headers:true).map(&:to_h)
  return hashedData
end

def join_tables(tableB,tableA,tableB_file,tableB_column,tableA_column)
  joined_table_array=[]
  tableB = CSV.parse(File.read(tableB_file), headers: true).map(&:to_h).take(5)    
  tableA.each do |rowA|
  result_hash={}
      tableB.each do |rowB|
          if rowB[tableB_column] === rowA[tableA_column]
          merged = rowA.merge(rowB)
           joined_table_array<<merged
          end
      end
  end
  joined_table_array
end

def insert_row(table_name,dataToInsert)
  CSV.open(table_name,"a+") do |csv|#test this in VsCode,it inserts data well without errors
    headers=csv.readline
   dataToInsert.each do |data|
     dataValues=headers.map do |header_name|
       data[header_name]
     end
     csv<< dataValues
    end  
end 
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

def merge_sort(array, &block)
  return array if array.length <= 1

  mid = array.length / 2 
  left = merge_sort(array[0...mid], &block)
  right = merge_sort(array[mid..-1], &block)
  merge(left, right, &block)
end


def merge(left, right, &block)
  result = []
  i = j = 0

  while i < left.length && j < right.length
    if block.call(left[i], right[j]) <= 0
      result << left[i]
      i += 1
    else
      result << right[j]
      j += 1
    end
  end

  result.concat(left[i..-1])
  result.concat(right[j..-1])

  result
end


request = MySqliteRequest.new
request = request.update('nba_player_data.csv')
request = request.values('name' => 'Alaa Renamed')
request = request.where('name', 'Alaa Abdelnaby')
request.run
