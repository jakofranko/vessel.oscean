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

  def template

    diary = $horaire.featuredDiaryWithTopic(name)

    return "
    <yu>
      #{diary ? diary.media.to_html : ""}
      #{diary && diary.name ? "<h2><a href='/#{name}'>#{name}</a></h2><hs>Updated "+logs.first.offset+"</hs>" : "" }
      <p>#{bref}</p>
    </yu>"

  end

end