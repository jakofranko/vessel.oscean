#!/bin/env ruby
# encoding: utf-8

class Index
  
  attr_accessor :indexes
  
  def initialize 

    @indexes = {}

  end

  def add parent,name

    parent = parent.to_s.downcase
    name = name.to_s.downcase
    if !@indexes then @indexes = {} end
    if !@indexes[parent] then @indexes[parent] = [] end
    @indexes[parent].push(name)

    return parent == "root" ? "<h2 id='#{name.downcase.gsub(' ','_')}'>#{name.capitalize}</h2>" : "<h3 id='#{name.downcase.gsub(' ','_')}'>#{name.capitalize}</h3>"

  end

  def to_s

    if !@indexes then return "Missing" end

    html = ""
    counter = 1
    sub_counter = 1
    @indexes.each do |parent,children| 
      if parent.to_s == "root" then next end   
      html += "<ln class='main'><t class='counter'>#{counter}.0</t> <a href='#{parent}'>#{parent.capitalize}</a></ln>"
      sub_counter = 1
      children.each do |child|
        sub_counter += 1
        html += "<ln><t class='counter'>#{counter}.#{sub_counter}</t> <a href='#{child}'>#{child.capitalize}</a></ln>"
      end
      counter += 1
    end
    return counter+sub_counter < 5 ? "" : "<yu id='index'>#{html}</yu>"

  end
  
end
