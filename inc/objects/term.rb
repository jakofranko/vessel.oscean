# encoding: utf-8
#: The {{Term}} object are {{Lexicon}} contructs.

class Term

  def initialize(data)
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
  	return @flags
  end

  def storage
  	return @storage.lines()
  end

  def definition
    return @definition
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
      if log.topic != @topic then next end
      logs.push(log)
    end
    return logs
  end

  def diaries
    result = []
    logs.each do |log|
      if log.topic != @topic then next end
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

  def photo
  	if @topic.to_i > 0 then return @topic.to_i end
  	photoAlbum = []
  	logs.each do |log|
  		if log.photo < 1 then next end
  		if log.topic != topic && topic != "Home" then next end
  		if log.isFeatured then return log.photo end
  		if log.topic == topic then photoAlbum.push(log.photo)
  		elsif log.title == topic then photoAlbum.push(log.photo)
  		end
  	end
  	if photoAlbum.length > 0 then return photoAlbum.first end
  	return 0
  end

  def template_lastUpdate
    html = ""

    logs.reverse.each do |log|
      if log.task != "Update" then next end
      html += "<h2>Version #{log.title}<small>Updated <a href='/#{topic}:changelog'>#{log.offset}</a></small></h2>"
      html += log.full
      return "<content class='update'>"+html+"</content>"
    end
    return ""
  end

  def template_links
    html = ""
    storage.each do |linkString,v| 
      link = Link.new(linkString)
      if link.type == "quote" then next end
      html += link.template
    end
    return "<content class='storage'>"+html+"</content>"
  end

  def template_readMore
    html = ""
    quotes = []
    storage.each do |linkString,v|
      link = Link.new(linkString)
      if link.type != "quote" then next end
      quotes.push(link)
    end
    if quotes.length == 0 then return "" end
    html += "<h2>Press</h2>"
    quotes.each do |link|
      html += link.template
    end
    return "<content class='readmore'>"+html+"</content>"
  end

  def template_portal
    html = ""

    # find root
    depth = 0
    parent = $page.topic
    while $lexicon.parent(parent) != parent
      if depth > 5 then return "" end
      if $lexicon.term(parent).flags.include?("portal") then break end
      parent = $lexicon.parent(parent)
      depth += 1
    end

    portalName = parent

    if portalName == "" then return "" end

    if File.exist?("img/interface/badge.#{portalName.downcase}.png")
      html += "<img src='img/interface/badge.#{portalName.downcase}.png' class='badge'/>"
    else
      html += "<img src='img/interface/badge.oscean.png' class='badge'/>"
    end

    if $lexicon.term(parent).children.length > 1
      html += "<li class='head'>{{"+portalName+" Portal|#{portalName}}}</li>"
      $lexicon.term(parent).children.each do |term|
        if $page.topic == $page.parent && $page.topic == term.topic then next end
        html += "<li><span class='cat'>{{"+term.topic+"}}</span><span class='sub'> "
        category = term.topic
        children = ""
        $lexicon.term(category).children.each do |term|
          children += "{{"+term.topic+"}}"
          children += " · "
        end
        html += children[0...-3]

        html += "</span></li>"
      end
    end
    return "<content class='portal'><ul>"+html+"</ul></content>"
  end

end