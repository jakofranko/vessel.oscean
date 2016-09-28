#!/bin/env ruby
# encoding: utf-8

class Oscea

  include Vessel

  class Corpse

    include CorpseHttp

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
      
      path = File.expand_path(File.join(File.dirname(__FILE__), "/"))

      if term.name.like("Unknown") then require_relative("pages/missing.rb") ; return end
      if File.exist?("#{path}/pages/#{@query.downcase}.rb") then require_relative("pages/#{@query.downcase}.rb") end
      if File.exist?("#{path}/modules/#{@query.downcase}.rb") then require_relative("modules/#{@query.downcase}.rb") end
      if term.type && File.exist?("#{path}/modules/#{term.type.downcase}.rb") then require_relative("modules/#{term.type.downcase}.rb") end
      if @module && File.exist?("#{path}/modules/#{@module.downcase}.rb") then require_relative("modules/#{@module.downcase}.rb") end

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
      #{links}
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

      return "6"
      return "<wr><p>#{term.bref.to_s.markup}</p>#{term.long.to_s.markup}</wr>"

    end

    def links

      if !term.link then return "" end

      html = ""
      term.link.each do |link|
        html += Link.new(link.first,link.last).template
      end
      return "<wr>"+html+"</wr>"

    end

  end

  class PassiveActions

    include ActionCollection

    def answer q = "Home"

      @query   = q.class == Array ? q.first.gsub("+"," ") : q.gsub("+"," ") 
      @module  = q.class == Array ? q.last : nil

      path = File.expand_path(File.join(File.dirname(__FILE__), "/"))

      load_folder("#{path}/objects/*")

      $lexicon = En.new("lexicon",path)
      $horaire = Di.new("horaire",path)

      # Corpse

      corpse = Corpse.new(q)      
      corpse.term = $lexicon.filter("term",@query,"term")
      corpse.horaire = Di.new("horaire",path)
      corpse.lexicon = En.new("lexicon",path)
      corpse.title = "XXIIVV ∴ #{corpse.term.name}"

      return corpse.result

    end

  end
  
  def passive_actions ; return PassiveActions.new(self,self) end

end