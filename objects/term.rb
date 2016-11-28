#!/bin/env ruby
# encoding: utf-8

class Term

  attr_accessor :name
  attr_accessor :unde
  attr_accessor :type
  attr_accessor :link
  attr_accessor :bref
  attr_accessor :long
  attr_accessor :logs

  def initialize name = "Unknown", data = {}

    data = data ? data : { "UNDE" => "HOME", "TYPE" => "Missing" }

    @name = "#{name}".downcase.capitalize
    @unde = data["UNDE"] ? data["UNDE"].downcase.capitalize : "Home"
    @type = data["TYPE"] ? data["TYPE"] : nil
    @link = data["LINK"]
    @bref = data["BREF"] ? data["BREF"].markup : nil
    @long = data["LONG"] ? data["LONG"] : []

    @logs = nil

  end

  def is_diary     ; return @module == "diary"    ? true : false end
  def is_task      ; return @module == "task"     ? true : false end
  def is_horaire   ; return @module == "horaire"  ? true : false end
  def has_diaries  ; return diaries.length > 0    ? true : false end
  def has_logs     ; return logs.length > 0       ? true : false end
  def has_tasks    ; return tasks.length > 0      ? true : false end
  
  def is_type t ; return type && type.like(t) ? true : false end

  def parent

    @parent = @parent ? @parent : @parent = $lexicon.filter("term",unde,"term")
    return @parent

  end

  def type_value

    if !@type then return nil end
    if !@type.include?(" ") then return nil end
    return @type.sub(type,"").strip.downcase.capitalize

  end

  def type

    if !@type then return nil end
    return @type.split(" ").first.downcase.capitalize

  end

  def tasks

    @tasks = @tasks ? @tasks : ( name.like("home") || name.like("diary") || name.like("horaire") ? $desktop.to_h("issue") : $desktop.filter("term",name,"issue"))
    return @tasks

  end

  def comments
    
    @comments = @comments ? @comments : ( name.like("home") || name.like("forum") ) ? $forum.to_a : $forum.filter("topic",name,"comment")
    return @comments

  end

  # Dynamo

  def logs

    @logs = @logs ? @logs : ( name.like("home") || name.like("diary") || name.like("horaire") ? $horaire.filter("term","*","log") : $horaire.filter("term",name,"log"))
    return @logs

  end

  def diaries

    if @diaries then return @diaries end

    @diaries = []
    logs.each do |log|
      if log.photo < 1 && log.full.to_s == "" then next end
      @diaries.push(log)
    end
    return @diaries

  end

  def diary

    if @diary then return @diary end
    if diaries.length < 1 then return nil end

    @diary = diaries.first

    diaries.each do |log|
      if log.isFeatured
        @diary = log
        break
      end
    end
    return @diary

  end

  def portal

    depth = 0
    t = self

    while !t.parent.name.like(self.name) 
      if depth > 5 then return "nataniev" end
      if t.is_type("Portal") then t = t ; break end
      t = t.parent
      depth += 1
    end
    return t ? t.name : "nataniev"

  end

  def to_s

    return "
    <yu>
      #{diary ? "<a href='/#{name}'>"+diary.media.to_s+"</a>" : ""}
      <h2><a href='/#{name}'>#{name}</a></h2>
      <p>#{bref}</p>
    </yu>"

  end

end
