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

  def to_s is_hash = false

    if !@indexes then return "Missing" end

    html = ""
    counter = 1
    sub_counter = 1
    @indexes.each do |parent,children| 
      if parent.to_s == "root" then next end   
      html += "<ln class='head'><a href='#{is_hash ? '#' : ''}#{parent.downcase.gsub(' ','_')}'>#{parent.capitalize}</a></ln>"
      sub_counter = 0
      children.each do |child|
        sub_counter += 1
        html += "<ln class='child'><a href='#{is_hash ? '#' : ''}#{child.downcase.gsub(' ','_')}'>#{child.capitalize}</a></ln>"
      end
      counter += 1
    end
    return counter+sub_counter < 5 ? "" : "<yu class='index'>#{html}</yu>"

  end
  
end
