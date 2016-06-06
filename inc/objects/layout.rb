# encoding: utf-8

class Layout

  def initialize page

    @page = page

  end

  # -----------------
  # Header
  # -----------------

  def layoutHeader

    html = ""
    html += layoutHeaderPhoto
    html += layoutHeaderTitle
    html += layoutHeaderSource

    return "<content class='header'>"+html+"</content>"

  end

  def layoutHeaderLogo

    html = ""
    html += "<a href='/'><img src='img/vectors/logo.svg' class='logo'/></a>"
    return "<content class='logo'>"+html+"</content>"

  end

  def layoutHeaderPhoto
  
    if !@page.diary then return "" end
    return "<content id='photo' class='photo' style='background-image:url(/content/diary/#{@page.diary.photo}.jpg)'></content>"

  end

  def layoutHeaderTitle

    html = ""
    html += layoutHeaderLogo
    html += (!@page.module.like("diary") && @page.diaries.length > 1 && !@page.term.name.like("home")) ? "<a class='module' href='/#{@page.term.name}:Diary'><img src='img/vectors/diary.svg' class='icon'/>#{@page.diaries.length} Diaries</a>" : ""
    html += (!@page.module.like("horaire") && @page.logs.length > 1 && !@page.term.name.like("home")) ? "<a class='module' href='/#{@page.term.name}:Horaire'><img src='img/vectors/log.svg' class='icon'/>#{@page.logs.length} Logs</a>" : ""

    html += @term && (@page.term.name.like("home")) ? "<a class='module' href='/Diary'><img src='img/vectors/diary.svg' class='icon'/>#{@page.diaries.length} Diaries</a>" : ""
    html += @term && (@page.term.name.like("home")) ? "<a class='module' href='/Horaire'><img src='img/vectors/log.svg' class='icon'/>#{@page.logs.length} Logs</a>" : ""

    return "<content class='title'><div class='search'><input placeholder='"+@page.title+"' id='query'/></div>"+html+"</content>"

  end

  def layoutHeaderSource

    if !@page.diary then return "" end
    return "<content class='source'><img src='img/vectors/feature.svg' class='icon'/> \"<a href='/#{@page.diary.topic}:diary'>#{@page.diary.title}</a>\" #{@page.diary.offset}.</content>"

  end

  def layoutBody

    return "<content class='body'>#{@page.body} #{layoutLinks}</content>"

  end

  def layoutLinks

    if !@page.links then return "" end

    html = ""
    @page.links.each do |name,url| 
      link = Link.new(name,url)
      html += link.template
    end
    return "<content class='storage'>"+html+"</content>"

  end

  # -----------------
  # Footer
  # -----------------

  def layoutPortal

    if !@term then return "" end
    return "<content class='portal'>#{layoutPortalIcon}#{layoutPortalTree}</content>"

  end

  def layoutPortalIcon

    if File.exist?("content/badges/#{@page.term.name.downcase.gsub(' ','.')}.png")
		return "<a href='/#{@page.portal.name}' class='badge'><img src='content/badges/#{@page.term.name.downcase.gsub(' ','.')}.png'/></a>"
    elsif File.exist?("content/badges/#{@page.portal.name.downcase.gsub(' ','.')}.png")
		return "<a href='/#{@page.portal.name}' class='badge'><img src='content/badges/#{@page.portal.name.downcase.gsub(' ','.')}.png'/></a>"
    else 
		return "<a href='#{@page.term.unde}' class='badge'><img src='content/badges/oscean.png'/></a>"
    end

  end

  def layoutPortalTree

  	html = "<ul>"
    html += (@page.portal.name != @page.term.name) ? "<li class='head'><a href='/#{@page.portal.name}'>#{@page.portal.name} Portal</a></li>" : "<li class='head'><b>#{@page.portal.name}</b></li>"
	html += "</ul>"

	html += "<ul class='siblings'>"
    @page.lexicon.siblings(@page.term).each do |term|
    	if term.name == "HOME" then next end
    	if term.name == @page.portal.name then next end
    	html += (term.name != @page.term.name) ? "<li><a href='/#{term.name}'>#{term.name}</a></li>" : "<li><b>#{term.name}</b></li>"
    end
    html += "</ul>"

    if @page.term.name != @page.portal.name
		html += "<ul class='children'>"
    	@page.lexicon.children(@page.term).each do |term|
	    	if term.name == "HOME" then next end
	    	if term.name == @page.term.name then next end
	    	html += (term.name != @page.term.name) ? "<li><a href='/#{term.name}'>#{term.name}</a></li>" : "<li><b>#{term.name}</b></li>"
	    end
	    html += "</ul>"
	end
    
    html += "</ul>"

    return html

  end

  def layoutFooter

    return "
    <content class='footer'>
    	<content>
        <dl class='icons'>
          <a href='/Oscean' class='icon'><img src='/img/interface/icon.oscean.png'/></a>
          <a href='https://github.com/neauoire' class='icon' target='_blank'><img src='img/interface/icon.github.png'/></a>
          <a href='https://twitter.com/neauoire' class='icon' target='_blank'><img src='img/interface/icon.twitter.png'/></a>
        </dl>
        <dl class='main'>
          <dd><a href='/Devine+Lu+Linvega'><b>Devine Lu Linvega</b></a> © 2009-#{Time.now.year} <a href='http://creativecommons.org/licenses/by-nc-sa/4.0/' target='_blank' style='color:#aaa'>BY-NC-SA 4.0</a></dd>
          <dd>Currently indexing #{@page.lexicon.all.length} projects, built over #{@page.horaire.length} days.</dd>
          <dd class='small'><a href='/Diary'>Diary</a> &bull; <a href='/Horaire'>Horaire</a> &bull; <a href='/Desamber' class='date'>"+Desamber.new().default+"</a><br /><a href='Clock'>"+Clock.new().default+"</a> "+((Time.new - $timeStart) * 1000).to_i.to_s+"ms</dd>
        </dl>
        </content>
        <hr />
    </content>"

  end

  #----------------
  # Layout View
  #----------------

  def view

    html = ""
    html += layoutHeader
    html += "<content class='main'>"
    html += layoutBody
    html += layoutPortal
    html += "</content>"
    html += layoutFooter
    html += "<hr />"
    return "<content>#{html}</content>"

  end

  def title

    return "XXIIVV ∴ "+@page.title
    
  end

end
