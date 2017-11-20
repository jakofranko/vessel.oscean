#!/bin/env ruby
# encoding: utf-8

$nataniev.require("corpse","http")

$nataniev.vessels[:oscean].path = File.expand_path(File.join(File.dirname(__FILE__), "/"))
$nataniev.vessels[:oscean].install(:custom,:serve,CorpseHttp.new)

corpse = $nataniev.vessels[:oscean].corpse

def corpse.build

  @host = $nataniev.vessels[:oscean]

  add_meta("description","Works of Devine Lu Linvega")
  add_meta("keywords","aliceffekt, traumae, devine lu linvega")
  add_meta("viewport","width=800, initial-scale=1, maximum-scale=1")
  add_meta("apple-mobile-web-app-capable","yes")

  add_link("reset.css",:lobby)
  add_link("font.input_mono.css",:lobby)
  add_link("font.frank_ruhl.css",:lobby)
  add_link("font.lora.css",:lobby)
  add_link("font.din.css",:lobby)
  add_link("font.archivo.css",:lobby)
  add_link("main.css")

  add_script("core/jquery.js",:lobby)
  add_script("main.js")
  add_script("aeth.js")
  add_script("septambres.js")
  add_script("gallery.js")
  add_script("clock.js")
  add_footer("<script>on_resize(); new Septambres().parse(); new Gallery().parse(); var clock = new Clock(); clock.start(); </script>")

end

def corpse.query q = nil

  @query   = q.include?(":") ? q.split(":").first : q
  @module  = q.include?(":") ? q.split(":").last : nil
  @query = @query.gsub("_"," ").gsub("+"," ")

  load_folder("#{@host.path}/objects/*")

  @lexicon = Memory_Hash.new(:lexicon,@host.path)
  @horaire = Memory_Array.new(:horaire,@host.path)

  @term    = @lexicon.filter("term",@query,"term")
  @title   = "XXIIVV ∴ #{@term.name}"

  load_any "#{@host.path}/pages",   @query
  load_any "#{@host.path}/modules", @query
  load_any "#{@host.path}/layouts", @term.type
  load_any "#{@host.path}/modules", @module

end

def corpse.body

  html = ""

  html += "
  #{search}
  #{header}
  <wr>
    #{@term.banner}
    <yu class='mi'><wr>#{view}</wr></yu>
    #{directory}
  </wr>
  #{footer}"
 
  return html

end

def corpse.search

  return "<yu class='search' id='search_panel'><a href='/#{@term.parent.name.to_url}'>#{@term.parent.name}</a> : <input type='text' id='search_input' placeholder='#{@term.name}'/></yu>"

end

def corpse.header

  html = ""
  html += "<yu class='logo'><a href='/Home'>#{@term.badge ? @term.badge : Media.new(:icon,:logo,:logo)}</a></yu>"
  html += @term.diary && @term.diary.media && !@term.has_flag(:no_photo) && !@term.is_type(:diary) ? "#{@term.diary.media}" : ''
  return "<yu class='hd'>#{html}</yu>"

end

def corpse.directory

  topics = {}
  @horaire.to_a(:log).each do |log|
    if !topics[log.topic] then topics[log.topic] = {} ; topics[log.topic][:from] = log.date end
    if log.task.like("release") then topics[log.topic][:release] = log.date end
    if log.task.like("prototype") then topics[log.topic][:prototype] = log.date end
    topics[log.topic][:to] = log.date
  end

  html = ""
  topics.each do |k,v|
    if !v[:release] && !v[:prototype] then next end
    date_format = v[:to].y.to_i == v[:from].y.to_i ? "#{v[:from].y}" : "#{v[:to].y}—#{v[:from].y}"
    if !v[:release] then date_format = "In Development" end
    html += "<ln>"+(k.to_url != @query.to_url ? "<a href='/#{k.to_url}'>#{k}</a>" : "<b>#{k}</b>")+" #{date_format}</ln>"
  end
  return "<yu class='directory'><list>#{html}</list></yu>"

end

def corpse.footer

  return "
  <yu class='ft'>
    <wr>
      <a title='Entaloneralie' href='/Desamber' id='clock' style='float:left; margin-right:20px; margin-top:5px; opacity:0.5'></a>
      <a title='Twitter' href='https://twitter.com/neauoire' target='_blank'>#{Media.new('icon','twitter')}</a>
      <a title='Github' href='https://github.com/neauoire' target='_blank'>#{Media.new('icon','github')}</a>
      <a title='Rotonde' href='dat://2f21e3c122ef0f2555d3a99497710cd875c7b0383f998a2d37c02c042d598485/' target='_blank'>#{Media.new('icon','rotonde')}</a>
      <a href='/Nataniev'>#{Media.new('icon','oscean').to_s}</a>
      <a href='/Devine+Lu+Linvega'><b>Devine Lu Linvega</b></a> © 2006—#{Time.now.year}<br /> 
      <a href='http://creativecommons.org/licenses/by-nc-sa/4.0/' target='_blank'>BY-NC-SA</a> 4.0 <t>Rendered in "+((Time.new - $nataniev.time) * 1000).to_i.to_s+"ms</t><br /> 
      <hr />
    </wr>
  </yu>"

end

def corpse.view; return "#{@term.long.runes}\n";end

def corpse.horaire; return @horaire; end
def corpse.lexicon; return @lexicon; end

class Media
  def path; return "#{$nataniev.path}/public/public.oscean/media" ; end
end


