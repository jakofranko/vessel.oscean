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

  def name

    return @NAME.downcase.capitalize

  end

  def unde
    
    return @UNDE.downcase.capitalize

  end

  def type

    if !@TYPE then return end
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

    if logs.length == 0
      logs_text = "No entries"
    elsif logs.length == 1
      logs_text = "#{logs.length} Logs, #{logs.last.date.default}"
    else
      logs_text = "#{logs.length} Log, #{logs.last.date.default}"
    end

    return "
    <content class='template term'>
      #{diary ? diary.image : ""}
      <h2><a href='/#{name}'>#{name}</a></h2>
      <h3>#{logs_text}</h3>
      <p>#{bref}</p>
    </content>"

  end

end