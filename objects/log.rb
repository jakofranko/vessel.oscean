#!/bin/env ruby
# encoding: utf-8

class Log

  def initialize(content)

    @log = content

  end

  def time
    Date.new(year,month,day).to_time.to_i
  end

  def year
    return @log['DATE'][0,4].to_i
  end

  def month
    return @log['DATE'][5,2].to_i
  end

  def day
    return @log['DATE'][8,2].to_i
  end

  def date
    return Desamber.new(@log['DATE'])
  end

  def elapsed
    return Time.new.to_i - Date.new(year,month,day).to_time.to_i
  end

  def offset

    if year < 1 then return "" end

    timeDiff = (elapsed/86400)

    if timeDiff < -1 then return "In "+(timeDiff*-1).to_s+" days" end
    if timeDiff == -1 then return "tomorrow" end
    if timeDiff == 0 then return "today" end
    if timeDiff == 1 then return "yesterday" end
    if timeDiff == 7 then return "a week ago" end
    if timeDiff > 740 then return (timeDiff/30/12).to_s+" years ago" end
    if timeDiff > 60 then return (timeDiff/30).to_s+" months ago" end
    if timeDiff > 30 then return "a month ago" end

    return timeDiff.to_s+" days ago"
  end

  def isPassed
    if Time.new.to_i > Date.new(year,month,day).to_time.to_i then return true end
    return false
  end

  def code
    return @log['CODE'].to_s != "" ? @log['CODE'] : nil
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
      return "audio"
    elsif verb == 2
      return "visual"
    elsif verb == 3
      return "research"
    end
    return "misc"
  end

  def name
    return @log['NAME'].to_s.force_encoding("UTF-8")
  end

  def full
    return @log['TEXT'].to_s.force_encoding("UTF-8").markup
  end

  def task
    return @log['TASK'].to_s
  end

  def photo
    return @log['PICT'].to_i
  end

  def topic
    return @log['TERM'].to_s
  end

  def isFeatured
    
    return rune == "!" ? true : nil

  end

  def isDiary

    return photo > 0 ? true : nil

  end

  def media

    return Media.new("diary",photo)
    
  end

  def to_s

    return "
    <yu class='di'>
      #{photo ? "<a href='/"+topic+"'>"+media.to_s+"</a>" : ""}
      #{name != "" ? "<h2>#{name}</h2><hs>#{date}</hs>" : ""}
      <p>#{full}</p>
    </yu>"

  end

  def preview

    return "
    <ln>
      <a class='tp #{sector}' href='/#{topic}'>#{topic}</a>
      <t class='tk'>#{task}</t>
      <a class='tl' href='/#{topic}:diary'>#{name}</a>
      <t class='dt'>#{offset}</t>
    </ln>"

  end

end
