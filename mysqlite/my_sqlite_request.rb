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
puts @where_conditions.inspect
#[{"name"=>"Matt Zunic"}, {"year_start"=>"2017"}]
#cli wrong
#[{"name "=>" Bill Zopf"}, {" year_start"=>"1971"}]
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

def update(table_name)
  @request='update'
  @table_name=table_name
  self
end
def self.update(table_name)
  MySqliteRequest.new.update(table_name)
end
def values(*data) #a hash of data key => value
@dataToInsert=data
puts dataToInsert.inspect #[{"name"=>"Matt Renamed", "year_start"=>"2017"}] normal
self
end
def set(*data) #a hash of data key => value
  @dataToInsert=data
  self
end

def delete
    @request='delete'
self
end

def run

    if File.exist?(@table_name)
      @hashedData=table_to_hashed(@table_name)
      else
      @hashedData=create_csv_file(@table_name,@dataToInsert) if !File.exist?(table_name)
    end
    @selected_hash_array=[] 
    @filtered_hash_array=[]
    @merged_hash_array=[]
    @final=[]
    
    
    if @isJoin
        joined_tables=join_tables(@hashedDataB,@hashedData,@filename_db_b,@column_on_db_b,@column_on_db_a)
        @hashedData=joined_tables
    end

       
    #convert table data in CSV::Row to a HashedData
    case @request
      when 'select' # select the columns  from the each table row and corresponding data
        @hashedData.each do |current_row|
            result_hash={}
            @all_conditions_met=true;

            process_row(current_row, result_hash, @selected_hash_array, @columns)
            @final=@selected_hash_array
        

                if @isWhere                
                @all_conditions_met=check_all_conditions_met(current_row,@where_conditions)
                process_row(current_row, result_hash, @filtered_hash_array, @columns)if @all_conditions_met  
                @final=@filtered_hash_array
                end #isWhere

                if @isOrder
                    sorted_hashes = if @order_type == :asc  
                      merge_sort(@final) { |a, b| a[order_col].downcase <=> b[@order_col].downcase }
                    elsif @order_type==:desc
                      merge_sort(@final) { |a, b| b[order_col].downcase <=> a[@order_col].downcase }
                    end
                @final=sorted_hashes
                end#isOrder
        end #end of table loop
        
   
    
      when 'insert' 
     
      insert_row(@table_name,@dataToInsert)
    
  
      when 'update'
    
    #@where_conditions [{"name"=>"Alaa Abdelnaby"}, {"year_start"=>"1991"}]
    updated_array=[]
    header=CSV.read(@table_name,headers:true).headers
      CSV.foreach(@table_name,headers:true) do |current_csv_row|
        all_conditions_met=check_all_conditions_met(current_csv_row,@where_conditions)
        if all_conditions_met
          #then update the row before pushing to the csv
            @dataToInsert.each do |current_condition|#[{"name"=>"Alaa Renamed", "college"=>"Renamed University"}]
              current_condition.each do |key,value|   
                current_csv_row[key]=value     #update the value of the current_csv_row
              end
            end
        end
         updated_array<<current_csv_row.to_h
         
        
          end#CSV.foreach
      
          CSV.open(@table_name,'w+',write_headers:true,headers:header) do |csv|
   
            updated_array.each do |current_updated_row|
              csv<<current_updated_row
            end
          end
      @final=updated_array

        when 'delete'
          
        table = CSV.table(@table_name) #delete_if is available in a tableMode,headers in it are symbols
        header=CSV.read(@table_name,headers:true).headers
       
        @where_conditions.each do |current_condition|
          current_condition.each do |key, value|
           # Delete rows that match the condition
            table.delete_if do |row| 
              row[key.to_sym] == value
            end
          end
        end
        
       
        csv_data=table.to_csv
        csv_array = CSV.parse(csv_data, headers: true).map(&:to_h) #convert to an array of hashes

        CSV.open(@table_name,'w',write_headers:true,headers:header) do |csv|
          csv_array.each do |row|
            csv<<row           
          end              
        end
      
      @final=csv_array
     
 end#case
        
  
    


 @final
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
  hashedData=CSV.parse(File.read(table_name),headers:true).map(&:to_h).take(10)
  return hashedData
end

def join_tables(tableB,tableA,tableB_file,tableB_column,tableA_column)
  joined_table_array=[]
  tableB = CSV.parse(File.read(tableB_file), headers: true).map(&:to_h)
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
  data_array=[]
  values_array=[]
  merged_hash={}
insert_index=0
  CSV.open(table_name,"a+") do |csv|#test this in VsCode,it inserts data well without errors
    headers=csv.readline
      dataToInsert.each do |data|
          if data.class == String
            values_array=dataToInsert
            csv<<values_array
          return
        end
      end

    keys_array = dataToInsert.map(&:keys).flatten
    
    dataToInsert.each do |data_hash|
      merged_hash.merge!(data_hash)
    end
    
     headers.each_with_index do |header_name,i|
      my_hash={}
      my_hash[header_name]= merged_hash[header_name]
      data_array<<my_hash
     end

      values_array=data_array.map do |data|
        data.values.first
     end
   
      csv << values_array
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
def check_all_conditions_met(current_row, where_conditions)
  all_conditions_met = true

  where_conditions.each do |current_condition|
    current_condition.each do |key, value|
      if current_row[key] != value
        all_conditions_met = false
        break
      end
    end
  end

  all_conditions_met
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

# request = MySqliteRequest.new
# request = request.update('nba_player_data.csv')
# request = request.values('name' => 'Matt Renamed','year_start'=>'2017')
# request = request.where('name', 'Matt Zunic')
# request = request.where('year_start', '2017')

# request.run
# request = MySqliteRequest.new
# request = request.insert('nba_player_data.csv')
# request = request.values('name' => 'Alaa Abdelnaby', 'year_start' => '1991', 'year_end' => '1995', 'position' => 'F-C', 'height' => '6-10', 'weight' => '240', 'birth_date' => "June 24, 1968", 'college' => 'Duke University')
# request.run


# request = MySqliteRequest.new
# request = request.from('nba_player_data.csv')
# request=request.select('*')
# request=request.join('weight','nba_players.csv','weight2')
# request.run

# request = MySqliteRequest.new
# request = request.from('nba_player_data.csv')
# request = request.select('name')
# request = request.where('college', "University of California, Los Angeles")
# request = request.where('year_start', '1970')

# request.run




# request = request.where('name', 'Paul Zipser')
# request.run
# request = MySqliteRequest.new
# request = request.update('nba_player_data.csv')
# request = request.values('name' => 'Alaa Renamed')
# request = request.where('name', 'Matt Zunic')
# request.run
# def join(column_on_db_a, filename_db_b, column_on_db_b)




















# request = MySqliteRequest.new
# request = request.update('nba_player_data.csv')
# request = request.values('name' => 'Alaa Renamed')
# request = request.where('name', 'Matt Zunic')
# request.run