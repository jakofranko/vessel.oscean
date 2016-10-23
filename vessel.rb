#!/bin/env ruby
# encoding: utf-8

$nataniev.require("corpse","http")

class Oscean

  include Vessel

  def path

    return File.expand_path(File.join(File.dirname(__FILE__), "/"))

  end

  class Corpse

    include CorpseHttp

    attr_accessor :path
    attr_accessor :term
    attr_accessor :horaire
    attr_accessor :lexicon

    def build

      add_meta("description","Works of Devine Lu Linvega")
      add_meta("keywords","aliceffekt, traumae, devine lu linvega")
      add_meta("viewport","width=device-width, initial-scale=1, maximum-scale=1")
      add_meta("apple-mobile-web-app-capable","yes")

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
        #{!term.is_diary   && term.has_diaries ? "<a class='md' href='/#{term.name}:diary'><img src='img/vectors/diary.svg'/>#{term.diaries.length} Diaries</a>" : ""}
        #{!term.is_horaire && term.has_logs    ? "<a class='md' href='/#{term.name}:horaire'><img src='img/vectors/log.svg'/>#{term.logs.length} Logs</a>" : ""}
        <input placeholder='#{term.name}' class='q'/>
        #{term.diary ? "<a href='/#{term.diary.photo}' class='md li'><img src='img/vectors/source.svg'/></a>" : ""}
      </wr>
      #{term.diary ? Media.new("diary",term.diary.photo) : ""}
    </yu>
    <yu class='cr'>
      #{view}
      #{links_}
    </yu>
    <yu class='ft'>
      <wr>
        <a href='/#{term.portal}'>#{ badge = Media.new("badge",term.name) ; badge.exists ? badge : badge = Media.new("badge",term.portal) ; badge.exists ? badge : badge = Media.new("badge","nataniev") ; badge }</a>
        <ln><a href='/Nataniev'>#{Media.new("interface","icon.oscean")}</a><a href='https://github.com/neauoire' target='_blank'>#{Media.new("interface","icon.github")}</a><a href='https://twitter.com/neauoire' target='_blank'>#{Media.new("interface","icon.twitter")}</a></ln>
        <ln><a href='/Devine+Lu+Linvega'><b>Devine Lu Linvega</b></a> © 2009-#{Time.now.year} <a href='http://creativecommons.org/licenses/by-nc-sa/4.0/' target='_blank' style='color:#aaa'>BY-NC-SA 4.0</a></ln>
        <ln>Currently indexing #{$lexicon.length} projects, built over #{$horaire.length} days.</ln>
        <ln><a href='/Diary'>Diary</a> &bull; <a href='/Horaire'>Horaire</a> &bull; <a href='/Desamber' class='date'>#{Desamber.new}</a><br /><a href='Clock'>#{Clock.new}</a> "+((Time.new - $nataniev.time) * 1000).to_i.to_s+"ms</ln>
      </wr>
    </yu>"

    end

    def view
      
      return "<wr><p>#{term.bref.to_s.markup}</p>#{term.long.to_s.markup}</wr>"

    end

    def links_

      if !term.link then return "" end

      html = ""
      term.link.each do |link|
        html += Link.new(link.first,link.last).to_s
      end
      return "<wr>"+html+"</wr>"

    end

  end

  class Actions

    include ActionCollection

    def serve q = "Home"

      @query   = q.include?(":") ? q.split(":").first.gsub("+"," ") : q.gsub("+"," ") 
      @module  = q.include?(":") ? q.split(":").last : nil

      path = File.expand_path(File.join(File.dirname(__FILE__), "/"))

      load_folder("#{path}/objects/*")

      $lexicon = En.new("lexicon",path)
      $horaire = Di.new("horaire",path)

      # Diary Id

      diary = @query.to_i > 0 ? $horaire.filter("pict",@query,"log").first : nil

      # Corpse

      corpse         = Corpse.new(@query)      
      corpse.term    = diary ? $lexicon.filter("term",diary.topic,"term") : $lexicon.filter("term",@query,"term")
      corpse.horaire = $horaire
      corpse.lexicon = $lexicon
      corpse.title   = "XXIIVV ∴ #{corpse.term.name}"
      corpse.path    = path

      load_any "#{path}/pages",   @query
      load_any "#{path}/modules", @query
      load_any "#{path}/modules", @module
      load_any "#{path}/modules", corpse.term.type

      return corpse.result

    end

  end
  
  def actions ; return Actions.new(self,self) end

end