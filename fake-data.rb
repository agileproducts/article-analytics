#!/usr/bin/env ruby

require 'securerandom'

if ARGV[0].nil? 
  abort "please supply the number of lines of fake data you want"
end

class FakeEvent
 
  attr_accessor :action
  attr_reader :uid,:time,:category,:action,:value

  def initialize(hash)
    hash.each {|k,v| instance_variable_set("@#{k}",v)}
  end

  def increment_time
    @time  += rand(60) #up to a minute
  end

  def increment_value
    max_increment = 100 - @value
    increment = rand(max_increment/10+1)*10 #only want multiples of ten
    @value += increment
  end

end

class EventBuffer

  MAX_SIZE = 10

  attr_accessor :events

  def initialize()
    @events = []
  end

  def add(event)
    if @events.size == MAX_SIZE then @events.delete_at(0) end
    @events.push event
  end

  def choose_random
    chosen_key = rand(@events.size)
    chosen_event = @events[chosen_key]
    @events.delete_at(chosen_key)
    chosen_event
  end

end

def new_article_view
  FakeEvent.new({:uid => SecureRandom.uuid, :time => start_clock, :category => "read_depth", :action => "start", :value => 0 })
end

def start_clock
  Time.now
end




 

@lines = ARGV[0]
@event_buffer = EventBuffer.new

(0..@lines.to_i).each do |line|
  if line < 10 
    event = new_article_view
    @event_buffer.add(event)
    puts "#{event.uid}|#{event.time}|#{event.category}|#{event.action}|#{event.value}"
  else
    chance = rand(5)
    if chance < 3 
      event =  @event_buffer.choose_random
      initial_value = event.value
      event.increment_time
      event.increment_value
      event.action = "scroll"
      unless initial_value == 100 then @event_buffer.add(event) end
      puts "#{event.uid}|#{event.time}|#{event.category}|#{event.action}|#{event.value}"
    else
      event = new_article_view
      @event_buffer.add(event)
      puts "#{event.uid}|#{event.time}|#{event.category}|#{event.action}|#{event.value}"
    end
  end
end


