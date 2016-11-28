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
      html += "<code>"
      @content.each do |name,tasks|
        html += "#{name}\n"
        tasks.each do |task|
          html += "- #{task}<br />"
        end
      end
      html += "</code>"
    elsif @content.length > 0
      html += "<code>"
      @content.each do |task|
        html += "- #{task}\n"
      end
      html += "</code>"
    end
    return html

  end

end
