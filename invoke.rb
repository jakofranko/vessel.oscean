#!/bin/env ruby
# encoding: utf-8

$nataniev.require("corpse","http")

$nataniev.vessels[:oscean].path = File.expand_path(File.join(File.dirname(__FILE__), "/"))

$nataniev.vessels[:oscean].install(:custom,:serve)

corpse = CorpseHttp.new($nataniev.vessels[:oscean])

corpse.add_meta("description","Works of Devine Lu Linvega")
corpse.add_meta("keywords","aliceffekt, traumae, devine lu linvega")
corpse.add_meta("viewport","width=device-width, initial-scale=1, maximum-scale=1")
corpse.add_meta("apple-mobile-web-app-capable","yes")
corpse.add_link("reset.css",:lobby)
corpse.add_link("font.input_mono.css",:lobby)
corpse.add_link("font.frank_ruhl.css",:lobby)
corpse.add_link("font.lora.css",:lobby)
corpse.add_link("font.din.css",:lobby)
corpse.add_script("core/jquery.js",:lobby)
corpse.add_link("main.css")
corpse.add_script("main.js")

class Media
  def path; return "#{$nataniev.path}/public/public.oscean/media" ; end
end

$nataniev.vessels[:oscean].corpse = corpse

def corpse.horaire; return @horaire; end
def corpse.lexicon; return @lexicon; end

def corpse.query q = nil

  @query   = q.include?(":") ? q.split(":").first : q
  @module  = q.include?(":") ? q.split(":").last : nil
  @query = @query.gsub("_"," ").gsub("+"," ")

  load_folder("#{$nataniev.vessels[:oscean].path}/objects/*")

  @lexicon = Memory_Hash.new("lexicon",$nataniev.vessels[:oscean].path)
  @horaire = Memory_Array.new("horaire",$nataniev.vessels[:oscean].path)

  @term    = @lexicon.filter("term",@query,"term")
  @title   = "XXIIVV ∴ #{@term.name}"

  load_any "#{$nataniev.vessels[:oscean].path}/pages",   @query
  load_any "#{$nataniev.vessels[:oscean].path}/modules", @query
  load_any "#{$nataniev.vessels[:oscean].path}/layouts", @term.type
  load_any "#{$nataniev.vessels[:oscean].path}/modules", @module

  # Build

  @view = view

  self.body = layout

end

def corpse.view
  
  return "#{@term.long.runes}\n"

end

def corpse.layout

  html = ""
  html += @term.diaries.length > 0 && @term.flag != 'no_photo' ? (media = @term.diary.media ; media.set_class(:photo) ; media.to_s) : ""

  html_links = ""  
  if @term.link
    @term.link.each do |link|
      html_links += Link.new(link.first,link.last).to_s+" "
    end
  end

  html += "
  <yu class='logo'><wr><a href='/Home'>#{Media.new(:icon,:logo,:logo)}</a></wr></yu>
  <yu class='hd #{@term.theme} #{@term.diaries.length > 0 ? 'has_photo' : 'no_photo'}'>
    <wr>
      <a href='/#{@term.parent.name}' class='portal'>#{Media.new("badge",@module).exists ? (badge = Media.new("badge",@module) ; badge.set_class('portal') ; badge) : @term.badge}</a>  
      <input id='search' value='#{@term.parent.name}' type='text' spellcheck='false' autocorrect='off'/>#{@term.logs.length > 5 ? Graph_Overview.new(@term) : ''}
      <list>
        <ln>#{@term.bref ? @term.bref : 'No description.'}</ln>
        <ln>#{html_links}</ln>
      </list>
    </wr>
  </yu>
  <yu class='mi'><wr>#{view}</wr></yu>
  <yu class='ft'>
    <wr>
      <ln>
        <a href='/Devine+Lu+Linvega' style='font-family:\"din_bold\"'><b>Devine Lu Linvega</b></a> © 2009-#{Time.now.year}<br /> 
        <a href='http://creativecommons.org/licenses/by-nc-sa/4.0/' target='_blank'>BY-NC-SA</a> 4.0
      </ln><ln>
        <a href='/Desamber'><b>#{Desamber.new}</b></a> <br />
        <a href='/portal'>#{@lexicon.length} Projects</a>, over <a href='/horaire'>#{@horaire.length} Days</a>
      </ln><ln>
        Updated #{Log.new(@horaire.render.first).time.ago}<br />
        <a href='/Nataniev'>Rendered in "+((Time.new - $nataniev.time) * 1000).to_i.to_s+"ms</a>
      </ln><ln>
        <a href='https://twitter.com/neauoire' target='_blank'>#{Media.new('icon','twitter')}</a>
        <a href='https://github.com/neauoire' target='_blank'>#{Media.new('icon','github')}</a>
      </ln>
      <hr />
    </wr>
  </yu>"

  return html

end
