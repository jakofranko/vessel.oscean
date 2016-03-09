# encoding: utf-8
#: The {{Term}} object are {{Lexicon}} contructs.

class Term

  def initialize(data = Hash["term" => "Home","parent"=>"Home","flags"=>"","storage"=>"","definition"=>""])
  	@topic      = data["term"].to_s.force_encoding("utf-8")
  	@parent     = data["parent"].to_s.force_encoding("utf-8")
  	@flags      = data["flags"].to_s.force_encoding("utf-8")
  	@storage    = data["storage"].to_s.force_encoding("utf-8")
  	@definition = data["definition"].to_s.force_encoding("utf-8")
  end

  def topic
  	return @topic
  end

  def parent
  	return @parent
  end

  def flags
  	return @flags.split(" ")
  end

  def storage
  	return @storage.lines()
  end

  def definition
    return macros(@definition)
  end

  def description
    if !@definition.include?("</p>") then return @definition end
    return @definition.split("</p>").first+"</p>"
  end

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
      if log.topic != @topic && @topic != "Home" then next end
      logs.push(log)
    end
    return logs
  end

  def diaries
    result = []
    logs.each do |log|
      if log.topic != @topic && @topic != "Home" then next end
      if log.photo == 0 then next end
      result.push(log)
    end
    return result
  end

  def issues
  	issues = []
  	$issues.each do |issue|
  		# if issue.topic != @topic then next end
  		issues.push(issue)
  	end
  	return issues
  end

  def issuesActive
  	active = []
  	issues.each do |issue|
  		if issue.active == false then next end
  		active.push(issue)
  	end
  	return active
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