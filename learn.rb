class Mysqlite
  attr_accessor :isOrder, :order_type, :order_col

  def initialize
    @isOrder = false
  end

  def order(order, column_name)
    @isOrder = true
    @order_type = order
    @order_col = column_name
    self
  end

  def run 
  if @isOrder
    final_array = [
  { name: "John", age: 25 },
  { name: "Alice", age: 30 },
  { name: "bob", age: 28 },
  { name: "aob", age: 28 }
  ]
  
      
    sorted_hashes = if @order_type == 'asc'
      merge_sort(final_array) { |a, b| a[order_col].downcase <=> b[@order_col].downcase }
    else
      merge_sort(final_array) { |a, b| b[order_col].downcase <=> a[@order_col].downcase }
    end

  end

  end#run
end#class

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






result = Mysqlite.new.order('des', :name).run
puts result.inspect