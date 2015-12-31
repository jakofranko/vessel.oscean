#!/bin/env ruby
# encoding: utf-8

class Layouts

  def initialize(data)

    $query   = data["topic"].downcase
    $module  = data["module"].downcase
    $lexicon = data["lexicon"]
    $horaire = data["horaire"]
    $issues  = data["issues"]
    $page    = $lexicon.term($query.capitalize)

    @featured = $page.featured

  end

  # -----------------
  # Header
  # -----------------

  def layoutHeader

    html = ""
    html += layoutHeaderLogo
    html += layoutHeaderPhoto
    html += layoutHeaderTitle

    return "<content class='header'>"+html+"</content>"

  end

  def layoutHeaderLogo

    html = ""
    html += "<a href='/'>"+Icon.new().logo(0.30)+"</a>"
    return "<content class='logo'>"+html+"</content>"

  end

  def layoutHeaderPhoto

    if $query.to_i > 0 then return "<content id='photo' class='photo' style='background-image:url(/content/diary/#{$query}.jpg)'></content>" end
    if @featured && @featured.photo > 0 then return "<content id='photo' class='photo' style='background-image:url(/content/diary/#{@featured.photo}.jpg)'></content>" end
    return ""

  end

  def layoutHeaderTitle

    html = "<div class='search'><div class='sector #{$page.sector}'></div><input placeholder='"+$page.topic+"' id='query'/></div>"

    if $module == "diary"
    	html += "<a class='module' href='/#{$page.topic}'>#{Icon.new.return}Return to #{$page.topic}</a>"
    elsif $page.topic == "Home"
    	html += "<a class='module' href='/Diary'>#{Icon.new.diary}#{$horaire.diaries.length} Diaries</a>"
    elsif $page.diaries.length > 1
    	html += "<a class='module' href='/#{$page.topic}:Diary'>#{Icon.new.diary}#{$page.diaries.length} Diaries</a>"
    elsif $query.to_i > 0
    	html += "<a class='module' href='/#{$horaire.diaryWithId($query).topic}'>#{Icon.new.return}Return to #{$horaire.diaryWithId($query).topic}</a>"
    end

    if $module == "horaire"
      html += "<a class='module' href='/#{$page.topic}'>#{Icon.new.return}Return to #{$page.topic}</a>"
    elsif $page.topic == "Home"
    	html += "<a class='module' href='Horaire'>#{Icon.new.horaire}#{$horaire.all.length} Logs</a>"
    elsif $page.logs.length > 1
    	html += "<a class='module' href='/#{$page.topic}:Horaire'>#{Icon.new.horaire}#{$page.logs.length} Logs</a>"
    end

    if $page.topic == "Home"
    	html += "<a class='module' href='/Issues'>#{Icon.new.issues}#{$page.issuesActive.length} Issues</a>"
    elsif $page.issuesActive.length > 0
      html += "<a class='module' href='/#{$page.topic}:Issues'>#{Icon.new.issues}#{$page.issuesActive.length} Issues</a>"
    end

    return "<content class='title'>"+html+"</content>"

  end

  def layoutHeaderSource

    if !@featured then return "" end

    html = ""
    html += "#{Icon.new.photo} \"{{#{@featured.title}|#{@featured.photo}}}\" updated #{@featured.offset}."
    return "<content class='source'>#{html}</content>"

  end

  # -----------------
  # Core
  # -----------------

  def layoutCore

    html = ""
    html += layoutCoreDefinition
    html += $page.template_portal

    return "<content class='core'>"+html+"</content>"

  end

  def layoutTheater

  	if $page.flags.include?("diary") || $module == "diary"
      require_relative "layouts/diary.rb"
      return "<content class='theater'>"+theater_diary+"</content>"
  	elsif $module && self.respond_to?("theater_#{$module.downcase}")
  		return "<content class='theater'>"+self.send("theater_#{$module.downcase}")+"</content>"
    end
    return ""

  end

  def layoutCoreDefinition

    html = ""

    # Page & Module
    if self.respond_to?($query)
      html = self.send($query).to_s+"</content>"
    # Module
    elsif $module && self.respond_to?("module_#{$module.downcase}")
      html = self.send("module_#{$module.downcase}")
    # Layouts
    elsif $page.flags.include?("sector")
      require_relative "layouts/sector.rb"
      html = sector
    elsif $page.flags.include?("text")
      require_relative "layouts/text.rb"
      html += $page.template_links
      html = text
    elsif $page.flags.include?("index")
      require_relative "layouts/index.rb"
      html = index
    elsif $horaire.diaryWithId($query) != nil
      html = $horaire.diaryWithId($query).full
    # Lexicon
    elsif $page.definition != ""
      html += $page.definition
      html += $page.template_links
    # 404
    else
      require_relative "pages/missing.rb"
      html = missing
    end
    return "<content class='definition'>"+html+"</content>"

  end

  # -----------------
  # Footer
  # -----------------

  def layoutFooter

    return "
    <content class='footer'>
        <dl class='icons'>
          <a href='/Oscean' class='icon'><img src='/img/interface/icon.oscean.png'/></a>
          <a href='https://github.com/neauoire' class='icon' target='_blank'><img src='img/interface/icon.github.png'/></a>
          <a href='https://twitter.com/neauoire' class='icon' target='_blank'><img src='img/interface/icon.twitter.png'/></a>
        </dl>
        <dl class='main'>
          <dd><a href='/About'><b>Devine Lu Linvega</b></a> © 2015 <a href='http://creativecommons.org/licenses/by-nc-sa/4.0/' target='_blank' style='color:#aaa'>BY-NC-SA 4.0</a></dd>
          <dd>Currently indexing "+$lexicon.length.to_s+" projects, built over "+$horaire.length.to_s+" days.</dd>
          <dd class='small'><a href='/Diary'>Diary</a> &bull; <a href='/Horaire'>Horaire</a> &bull; <a href='/Issues'>Issues</a> &bull; <a href='/Desamber' class='date'>"+Desamber.new().default+"</a><br /><a href='Clock'>"+Clock.new().default+"</a> "+((Time.new - $timeStart) * 1000).to_i.to_s+"ms</dd>
        </dl>
        <hr />
    </content>"

  end

  #----------------
  # Layout View
  #----------------

  def view

    # Load module
    if File.exist?("inc/modules/#{$module}.rb")
      require_relative "modules/#{$module}.rb"
    end

    # Load module's page
    if File.exist?("inc/modules/#{$query}.rb")
      require_relative "modules/#{$query}.rb"
    end

    # Load page
    if File.exist?("inc/pages/#{$query}.rb")
      require_relative "pages/#{$query}.rb"
    end

    html = ""
    html += layoutHeader
    html += "<content class='main'>"
    html += layoutHeaderSource
    html += layoutTheater.force_encoding("UTF-8")
    html += layoutCore.force_encoding("UTF-8")
    html += "</content>"
    html += layoutFooter
    html += "<hr />"

    return "<content>"+html.template.to_s+"</content>"

  end

  def title

    if $horaire.diaryWithId($query) then return "XXIIVV ∴ "+$horaire.diaryWithId($query).title end
    return "XXIIVV ∴ "+$page.topic
    
  end

end
