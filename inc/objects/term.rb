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

    html = ""
    @LONG.each do |line|
        rune = line[0,1]
        text = line.sub(rune,"").strip
        case rune
        when "&"
          html += "<p>#{text}</p>"
        when "-"
          html += "<l>#{text}</l>"
        when "?"
          html += "<p class='note'>#{text}</p>"
        when "*"
          html += "<h2>#{text}</h2>"
        when "#"
          html += "<pre>#{text}</pre>"
        when "%"
          html += "<img src='#{text}'/>"
        else
          html += "[??]#{text}[??]"
        end
      end

    return html

  end



  # OLD

  def siblings
    siblings = []
    $lexicon.all.sort.each do |topic,term|
      if term.parent != parent then next end
      siblings.push(term)
    end
    return siblings
  end

  def children
    children = []
    $lexicon.all.sort.each do |topic,term|
      if term.parent != self.topic then next end
      children.push(term)
    end
    return children
  end

  def logs
    logs = []
    $horaire.all.sort.each do |date,log|
      if log.topic != @topic && @topic != "HOME" then next end
      logs.push(log)
    end
    return logs
  end

  def diaries
    result = []
    logs.each do |log|
      if log.topic != @topic && @topic != "HOME" then next end
      if log.photo == 0 then next end
      result.push(log)
    end
    return result
  end

  def sector
    sectors = {}
    sectors["audio"] = 0
    sectors["visual"] = 0
    sectors["research"] = 0
    sectors["misc"] = 0
    logs.each do |log|
      sectors[log.sector] += log.value
    end
    return sectors.sort_by {|_key, value| value}.reverse.first[0]
  end

  def lastUpdate
    return logs.first.to_s
  end

  def firstUpdate
    return logs.last.to_s
  end

  def hours
    hours = 0
    logs.each do |log|
      hours += log.value
    end
  	return hours
  end

  def featured
    diaries.reverse.each do |log|
      if log.isFeatured == false then next end
      return log
    end
    diaries.reverse.each do |log|
      return log
    end
    return nil
  end

  def macros text

    search = text.scan(/(?:\{\{)([\w\W]*?)(?=\}\})/)
    search.each do |str,details|
        text = text.to_s.gsub("{{"+str+"}}",parser(str))
    end
    return text

  end

  def parser macro

    if macro.include?("lexicon:") then return "<img src='content/lexicon/#{topic.downcase}.#{macro.split(":")[1]}.png'/>" end
    return "{{#{macro}}}"

  end

end