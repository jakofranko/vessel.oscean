#!/bin/env ruby
# encoding: utf-8

$nataniev.require("corpse","http")

class VesselOscean

  include Vessel

  def initialize id = 0

    super

    @name = "Oscean"
    @path = File.expand_path(File.join(File.dirname(__FILE__), "/"))

    install(:default,:serve)
    install(:default,:find)
    install(:default,:complete)

  end

end

class ActionServe

  include Action

  def act q = "Home"

    @query   = q.include?(":") ? q.split(":").first.gsub("+"," ") : q.gsub("+"," ") 
    @module  = q.include?(":") ? q.split(":").last : nil

    load_folder("#{@host.path}/objects/*")

    $lexicon = Memory_Hash.new("lexicon",@host.path)
    $horaire = Memory_Array.new("horaire",@host.path)
    $desktop = Memory_Hash.new("desktop",@host.path)

    # Diary Id

    diary = @query.to_i > 0 ? $horaire.filter("pict",@query,"log").first : nil

    # Corpse

    corpse         = CorpseHttp.new(@host,@query)      
    corpse.term    = diary ? $lexicon.filter("term",diary.topic,"term") : $lexicon.filter("term",@query,"term")
    corpse.horaire = $horaire
    corpse.lexicon = $lexicon
    corpse.desktop = $desktop
    corpse.title   = "XXIIVV ∴ #{corpse.term.name}"

    load_any "#{@host.path}/pages",   @query
    load_any "#{@host.path}/modules", @query
    load_any "#{@host.path}/modules", @module
    load_any "#{@host.path}/layouts", corpse.term.type

    return corpse.result

  end

end

class ActionFind

  include Action

  def act q = "Home"

    horaire = Memory_Array.new("horaire",@host.path)

    array = []
    diaries = []
    horaire.to_a.each do |log|
      if !log["PICT"] then next end
      diaries.push(log["PICT"].to_i)
    end
    diaries = diaries.sort

    i = 1
    while i < 999
      if !diaries.include?(i) then return i end
      i += 1
    end
    return array

  end

end

class ActionComplete

  include Action

  def act q = nil

    horaire = Memory_Array.new("horaire",@host.path)

    array = []
    dates = []
    horaire.to_a.each do |log|
      dates.push(log['DATE'])
    end
    i = 0
    while i < (365 * 10)
      test2 = Time.now - (i * 24 * 60 * 60)
      y = test2.to_s[0,4]
      m = test2.to_s[5,2]
      d = test2.to_s[8,2]
      i += 1
      if !dates.include?("#{y} #{m} #{d}")
        array.push("#{y} #{m} #{d}")
      end
    end
    return array

  end
end

class CorpseHttp

  attr_accessor :path
  attr_accessor :term
  attr_accessor :horaire
  attr_accessor :lexicon
  attr_accessor :desktop

  def build

    add_meta("description","Works of Devine Lu Linvega")
    add_meta("keywords","aliceffekt, traumae, devine lu linvega")
    add_meta("viewport","width=device-width, initial-scale=1, maximum-scale=1")
    add_meta("apple-mobile-web-app-capable","yes")

    add_link("https://fonts.googleapis.com/css?family=Playfair+Display")
    
    add_link("style.reset.css")
    add_link("style.main.css")

    add_script("jquery.core.js")
    add_script("jquery.main.js")

  end

  def body
    
    return "
  <yu class='hd'>
    <wr>
      <a href='/' class='lg'><img src='img/vectors/logo.svg'/></a>
      #{!term.is_diary   && term.has_diaries ? "<a class='md' href='/#{term.name}:diary'><img src='img/vectors/diary.svg'/><b>Diary</b>#{term.diaries.length} Entries</a>" : ""}
      #{!term.is_horaire && term.has_logs    ? "<a class='md' href='/#{term.name}:horaire'><img src='img/vectors/log.svg'/><b>Horaire</b>#{term.logs.length} Logs</a>" : ""}
      #{!term.is_task    && term.has_tasks   ? "<a class='md' href='/#{term.name}:issues'><img src='img/vectors/task.svg'/><b>Issues</b>#{term.tasks.length} Tasks</a>" : ""}
      #{term.diary ? "<a href='/#{term.diary.photo}' class='md li'><img src='img/vectors/source.svg'/></a>" : ""}
      <input placeholder='$ #{term.name}' class='q'/>
    </wr>
    #{term.diary ? Media.new("diary",term.diary.photo) : ""}
  </yu>
  <yu class='cr'>
    <yu class='vi'>
      #{portal}
      #{view}
      #{_links}
    </yu>
    <hr/>
  </yu>
  <yu class='ft'>
    <wr>
      <ln><a href='/Nataniev'>#{Media.new("interface","icon.oscean")}</a><a href='https://github.com/neauoire' target='_blank'>#{Media.new("interface","icon.github")}</a><a href='https://twitter.com/neauoire' target='_blank'>#{Media.new("interface","icon.twitter")}</a></ln>
      <ln><a href='/Devine+Lu+Linvega'><b>Devine Lu Linvega</b></a> © 2009-#{Time.now.year} <a href='http://creativecommons.org/licenses/by-nc-sa/4.0/' target='_blank' style='color:#aaa'>BY-NC-SA 4.0</a></ln>
      <ln>Currently indexing #{$lexicon.length} projects, built over #{$horaire.length} days.</ln>
      <ln><a href='/Diary'>Diary</a> &bull; <a href='/Horaire'>Horaire</a> &bull; <a href='/Desamber' class='date'>#{Desamber.new}</a><br /><a href='Clock'>#{Clock.new}</a> "+((Time.new - $nataniev.time) * 1000).to_i.to_s+"ms</ln>
    </wr>
  </yu>"

  end

  def portal

    if term.portal.name.like(term.name) then return "" end
    return "<yu class='si'><wr><a href='/#{term.portal.name}'>#{ badge = Media.new("badge",term.name) ; badge.exists ? badge : badge = Media.new("badge",term.portal.name) ; badge.exists ? badge : badge = Media.new("badge","nataniev") ; badge }</a><p>#{term.portal.bref}</p></wr></yu>"

  end

  def view
    
    return "<wr><p>#{term.bref.to_s}</p>#{term.long.runes.to_s}</wr>"

  end

  def _links

    if !term.link then return "" end

    html = ""
    term.link.each do |link|
      html += Link.new(link.first,link.last).to_s
    end
    return "<wr>"+html+"</wr>"

  end

end