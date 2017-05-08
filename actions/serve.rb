#!/bin/env ruby
# encoding: utf-8

$nataniev.require("corpse","http")

class ActionServe

  include Action

  def initialize q = nil

    super

    @name = "Serve"
    @docs = "Deliver the Oscean wiki."

  end

  def act q = "Home"

    @query   = q.include?(":") ? q.split(":").first.gsub("+"," ") : q.gsub("+"," ")
    @module  = q.include?(":") ? q.split(":").last : nil

    load_folder("#{@host.path}/objects/*")

    $lexicon = Memory_Hash.new("lexicon",@host.path)
    $horaire = Memory_Array.new("horaire",@host.path)
    $desktop = Memory_Hash.new("desktop",@host.path)
    $forum   = Memory_Array.new("forum",@host.path)

    # Diary Id

    diary = @query.to_i > 0 ? $horaire.filter("pict",@query,"log").first : nil

    # Corpse
    
    corpse         = CorpseHttp.new(@host,@query)
    corpse.term    = diary ? $lexicon.filter("term",diary.topic,"term") : $lexicon.filter("term",@query,"term")
    corpse.module  = @module
    corpse.horaire = $horaire
    corpse.lexicon = $lexicon
    corpse.desktop = $desktop
    corpse.forum   = $forum
    corpse.title   = "XXIIVV ∴ #{corpse.term.name}"

    load_any "#{@host.path}/pages",   @query
    load_any "#{@host.path}/modules", @query
    load_any "#{@host.path}/layouts", corpse.term.type
    load_any "#{@host.path}/modules", @module

    return corpse.result

  end

end

class CorpseHttp

  attr_accessor :path
  attr_accessor :term
  attr_accessor :module
  attr_accessor :horaire
  attr_accessor :lexicon
  attr_accessor :desktop
  attr_accessor :forum
  
  def build

    add_meta("description","Works of Devine Lu Linvega")
    add_meta("keywords","aliceffekt, traumae, devine lu linvega")
    add_meta("viewport","width=device-width, initial-scale=1, maximum-scale=1")
    add_meta("apple-mobile-web-app-capable","yes")
    
    add_link("style.reset.css")
    add_link("style.fonts.css")
    add_link("style.main.css")

    add_script("jquery.core.js")
    add_script("jquery.main.js")

  end

  def body
    
    return "
  <yu class='hd'>
    <wr>
      <a href='/Home' class='lg'>#{Media.new("icon","logo")}</a>
      #{!term.is_diary   && term.has_diaries ? "<a class='md' href='/#{term.name}:diary'>#{Media.new("icon","diary")}<b>Diary</b>#{term.diaries.length} Entries</a>" : ""}
      #{!term.is_horaire && term.has_logs    ? "<a class='md' href='/#{term.name}:horaire'>#{Media.new("icon","log")}<b>Horaire</b>#{term.logs.length} Logs</a>" : ""}
      #{!term.is_task    && term.has_tasks   ? "<a class='md' href='/#{term.name}:issues'>#{Media.new("icon","task")}<b>Issues</b>#{term.tasks.length} Tasks</a>" : ""}
      #{!term.type ? "<a class='md' href='/#{term.name.like("home") ? "forum" : term.name+":forum"}'>#{Media.new("icon","forum")}<b>Forum</b>#{term.comments.length} Comments</a>" : ""}
    </wr>
    #{term.diary ? (photo = Media.new("diary",term.diary.photo); photo.set_class("photo") ; photo.to_s) : ""}
  </yu>
  <yu class='cr'>
    <wr>
      #{_portal}
      <yu class='vi'>
        #{view}
      </yu>
    </wr>
    <hr/>
  </yu>
  <yu class='ft'>
    <wr>
      <span>
        <a href='/Devine+Lu+Linvega' style='margin-right:5px'><b>Devine Lu Linvega</b></a> © 2009-#{Time.now.year}<br />
        <a href='/portal'>#{$lexicon.length} Projects</a>, over <a href='/horaire'>#{$horaire.length} Days</a><br />
        <a href='http://creativecommons.org/licenses/by-nc-sa/4.0/' target='_blank'>BY-NC-SA 4.0</a><br />
      </span>
      <span>
        <a href='/Desamber'><b>#{Desamber.new}</b></a> <br />
        Updated #{Log.new($horaire.render.first).offset}<br />
        <a href='/Nataniev'>Render "+((Time.new - $nataniev.time) * 1000).to_i.to_s+"ms</a><br /> 
      </span>
      <span>
        <b>Social</b><br />
        <a href='https://twitter.com/neauoire' target='_blank'>Twitter Account</a><br />
        <a href='https://github.com/neauoire' target='_blank'>Github Sources</a><br />
      </span>
      <hr />
      <span>
        <a href='/Nataniev'>#{Media.new("badge","Nataniev")}</a>
        <a href='/Ronin'>#{Media.new("badge","Ronin")}</a>
      </span>
    </wr>
  </yu>"

  end
  
  def _portal
    
    t = ""

    siblings = ""
    term.siblings.each do |sibling|
      siblings += sibling.name.like(term.name) ? "<b>"+sibling.name+"</b> " : "<a href='/#{sibling.name}' class='sibling'>#{sibling.name}</a> "
    end
    if !term.name.like(term.unde)
      children = ""
      term.children.each do |child|
        children += child.name.like(term.name) ? "<b>"+child.name+"</b> " : "<a href='/#{child.name}' class='child'>#{child.name}</a> "
      end
    end

    input = !term.name.like(term.unde) ? "<input placeholder='#{term.name}' value='#{term.name}' class='q'/>" : "<input placeholder='Search' class='q'/>"
    
    return "<yu class='portal'><a href='/#{term.portal}' class='portal'>#{term.badge}</a><h2 class='#{term.unde.length > 8 ? "small" : "default"}'><a href='/#{term.unde}'>#{term.unde}</a></h2>#{input}<list>#{siblings}#{children}</list>#{_links}</yu>"
    
  end
  
  def style
    
    return ""
    
  end

  def view
    
    return "<p>#{term.bref}</p>#{term.long.runes.to_s}"

  end

  def _links
  
    if !term.link then return "" end

    html = ""
    term.link.each do |link|
      html += Link.new(link.first,link.last).to_s
    end
    return "<yu class='lk'>"+html+"</yu>"

  end

end
