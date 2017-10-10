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
  add_footer("<script>on_resize(); new Septambres().parse();</script>")

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
  <wr>
    <yu class='logo'><a href='/Home'>#{@term.badge ? @term.badge : Media.new(:icon,:logo,:logo)}</a></yu>
    #{header}
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

  html_links = ""  
  if @term.link
    @term.link.each do |link|
      html_links += Link.new(link.first,link.last).to_s+" "
    end
  end

  html += "<p>#{@term.bref}</p>"
  html += @term.logs.length > 0 ? "<mini>Updated <a href='/#{@term.name.to_url}:horaire'>#{@term.logs.first.time.ago}</a> #{html_links}</mini>" : "<mini>#{html_links}</mini>"
  html += "#{@term.diary && @term.diary.media && !@term.has_flag(:no_photo) && !@term.is_type(:diary) ? "<a href='/Diary'>"+@term.diary.media.to_img+"</a>" : ''}"
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
      <a href='/Rotonde'>#{Media.new('icon','oscean').to_s}</a>
      <a href='https://twitter.com/neauoire' target='_blank'>#{Media.new('icon','twitter')}</a>
      <a href='https://github.com/neauoire' target='_blank'>#{Media.new('icon','github')}</a>
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


