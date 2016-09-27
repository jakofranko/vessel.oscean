#!/bin/env ruby
# encoding: utf-8

class Term

  def initialize(name = "Unknown", content = {})

  	@NAME = "#{name}"
  	@UNDE = content["UNDE"] ? content["UNDE"] : "Home"
  	@TYPE = content["TYPE"]
  	@LINK = content["LINK"]
  	@BREF = content["BREF"]
    @LONG = content["LONG"]

    @LOGS = nil

  end
  
  def is_type t ; return type && type.like(t) ? true : false end

  def name

    return @NAME.downcase.capitalize

  end

  def unde
    
    return @UNDE.downcase.capitalize

  end

  def parent

    @parent = @parent ? @parent : @parent = $lexicon.term(unde)
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

  def logs

    @LOGS = !@LOGS ? $horaire.logsWithTopic(name) : @LOGS

    return @LOGS

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

  def template

    diary = $horaire.featuredDiaryWithTopic(name)

    return "
    <yu>
      #{diary ? diary.media : ""}
      #{diary && diary.name ? "<h2><a href='/#{name}'>#{name}</a></h2><hs>Updated "+logs.first.offset+"</hs>" : "" }
      <p>#{bref}</p>
    </yu>"

  end

end