def integer_to_roman(param_1)
  numeralHash = {
    1000 => 'M',
    900 => 'CM',
    500 => 'D',
    400 => 'CD',
    100 => 'C',
    90 => 'XC',
    50 => 'L',
    40 => 'XL',
    10 => 'X',
    9 => 'IX',
    5 => 'V',
    4 => 'IV',
    1 => 'I'
  }

 
  result = ""
 numeralHash.each do |key,value|
    while param_1 >= key
      result += value
      param_1 -= key
    end
  end

  result
end

puts integer_to_roman(395)  
