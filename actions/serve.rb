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
    $forum   = Memory_Array.new("forum",@host.path)

    # Diary Id

    diary = @query.to_i > 0 ? $horaire.filter("pict",@query,"log").first : nil

    # Corpse
    
    corpse         = CorpseHttp.new(@host,@query)
    corpse.term    = diary ? $lexicon.filter("term",diary.topic,"term") : $lexicon.filter("term",@query,"term")
    corpse.module  = @module
    corpse.horaire = $horaire
    corpse.lexicon = $lexicon
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
    
    add_link("reset.css",:lobby)
    add_link("font.input_mono.css",:lobby)
    add_link("font.frank_ruhl.css",:lobby)
    add_link("font.lora.css",:lobby)
    add_link("font.din.css",:lobby)
    
    add_script("core/jquery.js",:lobby)
    add_script("core/invocate.js",:lobby)
    add_script("core/terminal.js",:lobby)

    add_link("main.css")
    add_script("main.js")

  end

  def _hd

    return "
    <yu class='hd #{term.theme} #{term.diaries.length > 0 ? 'has_photo' : ''}'>
      <wr>
        <a href='/#{term.parent.name}' class='portal'>
          #{Media.new("badge",@module).exists ? (badge = Media.new("badge",@module) ; badge.set_class('portal') ; badge) : term.badge}
        </a>        
        <list>
          <ln style='break-after: column; break-before: column '>#{!term.parent.name.like(term.name) ? '<a class=\'parent\' href=\'/'+term.parent.name+'\'>'+term.parent.name+'</a>' : ''} <input id='search' value='#{term.name.like('home') ? 'Jiiv' : term.name.capitalize}' type='text' spellcheck='false' autocorrect='off'/><br />#{term.bref}</ln>
          <ln>
            #{@module                                                     ? "<a class='md' href='/#{term.name}'>Return #{term.name}</a>" : ""}
          </ln>
        </list>
        <list class='links'>
          #{_links}
        </list>
      </wr>
    </yu>"

  end

  def _mi

    return "<yu class='mi'>#{term.diaries.length > 0 ? term.diary.media : ''}<wr>"+view+"#{_tags}#{term.logs.length > 5 ? Graph_Overview.new(term) : ''}</wr></yu>"

  end

  def _ft

    return "
    <yu class='ft'>
      <wr>
        <ln>
          <a href='/Devine+Lu+Linvega' style='margin-right:5px'><b>Devine Lu Linvega</b></a> © 2009-#{Time.now.year}<br /> 
          <a href='http://creativecommons.org/licenses/by-nc-sa/4.0/' target='_blank'>BY-NC-SA</a> 4.0
        </ln><ln>
          <a href='/Desamber'><b>#{Desamber.new}</b></a> <br />
          <a href='/portal'>#{$lexicon.length} Projects</a>, over <a href='/horaire'>#{$horaire.length} Days</a>
        </ln><ln>
          Updated #{Log.new($horaire.render.first).time.ago}<br />
          <a href='/Nataniev'>Rendered in "+((Time.new - $nataniev.time) * 1000).to_i.to_s+"ms</a>
        </ln><ln>
          <a href='https://twitter.com/neauoire' target='_blank'>#{Media.new('icon','twitter')}</a>
          <a href='https://github.com/neauoire' target='_blank'>#{Media.new('icon','github')}</a>
        </ln>
        <hr />
      </wr>
    </yu>"

  end

  def view

    return "#{@term.long.runes}\n"

  end

  def _tags

    if !term.tags then return "" end

    html = ""

    term.tags.each do |tag|
      html += "<a href='/#{tag}:tag' class='tag'>#{tag}</a>"
    end

    return html

  end

  def _links
  
    if !term.link then return "" end

    html = ""
    term.link.each do |link|
      html += Link.new(link.first,link.last).to_s+" "
    end
    return "#{html}"

  end

  def body
    
    return "
    #{_hd}
    #{_mi}
    #{_ft}"
    
  end
  
  def style
    
    return ""
    
  end

end
