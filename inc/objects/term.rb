# encoding: utf-8

class Term

  def initialize(name = "MISSING", content = {})

  	@NAME = "#{name}"
  	@UNDE = content["UNDE"].to_s
  	@TYPE = content["TYPE"]
  	@LINK = content["LINK"]
  	@BREF = content["BREF"]
    @LONG = content["LONG"]

    @LOGS = []

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
      
    return "<p>#{@BREF}</p>"

  end

  def long
    
    if !@LONG then return end

    return @LONG.runes

  end

end