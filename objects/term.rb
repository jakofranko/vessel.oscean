#!/bin/env ruby
# encoding: utf-8

class Term

  def initialize name = "Unknown", content = {}

    @NAME = "#{name}"

    content = content ? content : { "UNDE" => "HOME", "TYPE" => "Missing" }

    @UNDE = content["UNDE"] ? content["UNDE"] : "Home"
    @TYPE = content["TYPE"]
    @LINK = content["LINK"]
    @BREF = content["BREF"]
    @LONG = content["LONG"]

    @logs = nil

  end

  def is_diary     ; return @module == "diary"    ? true : false end
  def is_horaire   ; return @module == "horaire"  ? true : false end
  def has_diaries  ; return diaries.length > 0    ? true : false end
  def has_logs     ; return logs.length > 0       ? true : false end
  
  def is_type t ; return type && type.like(t) ? true : false end

  def name

    return @NAME.downcase.capitalize

  end

  def unde
    
    return @UNDE.downcase.capitalize

  end

  def parent

    @parent = @parent ? @parent : @parent = $lexicon.filter("term",unde,"term")
    return @parent

  end

  def type

    if !@TYPE then return nil end
    return @TYPE.downcase.capitalize

  end

  def link
    
    return @LINK

  end

  def bref
    
    if !@BREF then return end
      
    return @BREF

  end

  def long
    
    if !@LONG then return end

    return @LONG.runes

  end

  # Dynamo

  def logs

    @logs = @logs ? @logs : ( name.like("home") ? $horaire.filter("term","*","log") : $horaire.filter("term",name,"log"))
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
    return t.name

  end

  def to_s

    return "
    <yu>
      #{diary ? diary.media : ""}
      #{diary && diary.name ? "<h2><a href='/#{name}'>#{name}</a></h2><hs>Updated "+logs.first.offset+"</hs>" : "" }
      <p>#{bref}</p>
    </yu>"

  end

end