#!/bin/env ruby
# encoding: utf-8

class Comment
  
  attr_accessor :id
  
  def initialize content
    
    @content = content
    
  end
  
  def author
    
    if @content['MESSAGE'].to_s == "" then return nil end
    return @content['MESSAGE'].split(" ").last[0,1] == "~" ? @content['MESSAGE'].split(" ").last.sub("~","") : nil
    
  end
  
  def timestamp
    
    return Timestamp.new(@content['TIMESTAMP'])
    
  end
  
  def nest
    
    return @content['NEST'].to_i > 0 ? @content['NEST'].to_i : nil
    
  end
  
  def topic
    
    return @content['TOPIC']
    
  end
  
  def message
    
    if @content['MESSAGE'].to_s == "" then return nil end
    # Remove author
    text = author ? @content['MESSAGE'].split(" ")[0,@content['MESSAGE'].split(" ").length-1].join(" ") : @content['MESSAGE']
    
    return text
    
  end
  
  def to_s
    
    return "<comment "+(nest ? "class='nested'" : "")+">"+(message ? message : "This comment has been deleted.")+" <span class='timestamp'>#{timestamp.ago}</span>"+(author ? " by ~#{author}" : "")+"</comment>\n"
    
  end
  
end
