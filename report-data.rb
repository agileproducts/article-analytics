#! /usr/bin/env ruby

require 'csv'
require 'time'

if ARGV[0].nil?
  abort "please supply an input file"
end

def histogram(hash)
  hash.inject({}) do |result,element|
    #element = "8a29a9ef-b2c1-4d95-9d80-c6447aed0657"=>{:time_start=>"2016-01-22 13:38:40 +0000", :depth=>0}
    depth = element.flatten[1][:depth] 
    if result.has_key? depth         
      result[depth] += 1
    else
      result.merge!({depth => 1})
    end
    result
    #{0 => 100, 10 => 87, 20 => 73.. etc}
  end
end

def mean(hash, field)
  i = 0
  sum = hash.inject(0) do |result,element|
    field_value = element.flatten[1][field.to_sym]
    result += field_value
    i +=1
    result
  end
  (sum/i).round(1)
end





@data = {}

CSV.foreach(ARGV[0], :col_sep => "|") do |line|
  unless @data.has_key? line[0]
    @data.merge!({"#{line[0]}" => {:time_start => Time.parse(line[1]), :duration=>0.0, :depth => line[4].to_i }})
  else
    start_time = @data["#{line[0]}"][:time_start]
    @data["#{line[0]}"].merge!({:duration => Time.parse(line[1]) - start_time, :depth => line[4].to_i})
  end
end


p @data
hist = histogram(@data).sort.map {|a| a[1]}
puts hist

average_time = mean(@data, "duration")
puts average_time


#histogram of depth
#mean depth
#binned histogram of time
#median time



