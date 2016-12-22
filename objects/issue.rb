#!/bin/env ruby
# encoding: utf-8

class Issue

  def initialize name = "Unknown", content = []

    @content = content

  end

  def length

    if !@content then return 0 end
    return @content.length

  end

  def to_a

    return @content

  end

  def to_s
    
    html = ""
    if @content.is_a?(Hash)
      html += "<table>"
      @content.each do |name,tasks|
        html += "<tr><th rowspan='#{tasks.length}'>#{name}</th><td>#{tasks.first}</td></tr>\n"
        tasks.shift
        tasks.each do |task|
          html += "<tr><td>#{task}</td></tr>"
        end
      end
      html += "</table>"
    elsif @content.length > 0
      html += "<table>"
      html += "<tr><th>General Tasks</th></tr>\n"
      @content.each do |task|
        html += "<tr><td>#{task}</td></tr>\n"
      end
      html += "</table>"
    end
    return html

  end

end
