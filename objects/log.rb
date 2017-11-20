#!/bin/env ruby
# encoding: utf-8

class Log

  attr_accessor :topic
  attr_accessor :time
  attr_accessor :date
  attr_accessor :name
  attr_accessor :full
  attr_accessor :task
  attr_accessor :photo
  attr_accessor :code
  attr_accessor :forecast

  def initialize(content)

    @log = content

    @time  = Timestamp.new(@log['DATE'])
    @date  = Desamber.new(@log['DATE'])

    @topic = @log['TERM'].to_s
    @name  = @log['NAME'].to_s.force_encoding("UTF-8")
    @full  = @log['TEXT'].to_s.force_encoding("UTF-8").markup
    @task  = @log['TASK'].to_s
    @photo = @log['PICT'].to_i
    @code  = @log['CODE'].to_s.like("") ? nil : @log['CODE']

    @forecast = nil
    
  end

  def rune
    return code ? code[0,1] : nil
  end

  def verb
    return code ? code[2,1].to_i : 0
  end

  def value
    return code ? code[3,1].to_i : 0
  end

  def sector
    
    if verb.to_i == 1
      return :audio
    elsif verb == 2
      return :visual
    elsif verb == 3
      return :research
    end
    return :misc
    
  end

  def is_featured # Use for home
    
    return rune == "@" ? true : nil

  end

  def is_highlight
    
    return rune == "!" || rune == "@" ? true : nil

  end

  def is_event
    
    return rune == "+" ? true : nil

  end

  def isDiary

    return photo > 0 ? true : nil

  end

  def media

    return Media.new("diary",photo)
    
  end

  def theme

    if rune == "N" then return "noir" end
    if rune == "~" then return "no_photo" end

    return "default"

  end

  def term

    return $nataniev.vessels[:oscean].corpse.lexicon.filter(:term,topic,:term)

  end

  def to_s

    return "
    <yu class='di'>
      #{photo ? "<a href='/"+@topic.to_url+"'>"+media.to_img.to_s+"</a>" : ""}
      #{term.banner}
      #{name.to_s != "" ? "<p>#{full}</p><mini><b>"+name+"</b>, #{date}</mini>" : ""}
    </yu>"

  end

  def preview

    return "
    <ln>
      <a class='tp #{sector}' href='/#{topic}'>#{topic}</a>
      <t class='tk'>#{task}</t>
      <t class='date'>#{offset}</t>
    </ln>"

  end

end
