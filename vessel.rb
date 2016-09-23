#!/bin/env ruby
# encoding: utf-8

$vessel_path = File.expand_path(File.join(File.dirname(__FILE__), "/"))

$timeStart = Time.new

Dir["#{$vessel_path}/inc/objects/*"].each do |file_name|
  load(file_name)
end

class Oscea

  include Vessel

  class Corpse

    include CorpseHttp

    def title

      return "XXIIVV ∴ "+@page.title

    end

    def body q = "Home"

      # SHIT

      @query = q != "" ? q.gsub("+"," ").split(":").first : "Home"
      @module = q.include?(":") ? q.gsub("+"," ").split(":").last : ""

      @data = {
        "topic"   => @query,
        "module"  => @module,
        "lexicon" => En.new("lexicon").to_h,
        "horaire" => Di.new("horaire").to_a
      }

      @page   = Page.new(@data)

      $photo = @page.diary ? @page.diary.photo : nil

      # Header

      html_header = ""

      html_header += Media.new("diary",@page.diary.photo).to_html

      # 

      html_header += "<content class='title'><div class='search'><input placeholder='#{@page.title}' id='query'/>"
      html_header += "<content class='logo'><a href='/'><img src='img/vectors/logo.svg' class='logo'/></a></content>"
      html_header += (!@page.module.like("diary") && @page.diaries.length > 1 && !@page.term.name.like("home")) ? "<a class='module' href='/#{@page.term.name}:Diary'><img src='img/vectors/diary.svg' class='icon'/>#{@page.diaries.length} Diaries</a>" : ""
      html_header += (!@page.module.like("horaire") && @page.logs.length > 1 && !@page.term.name.like("home")) ? "<a class='module' href='/#{@page.term.name}:Horaire'><img src='img/vectors/log.svg' class='icon'/>#{@page.logs.length} Logs</a>" : ""
      html_header += @page.term && (@page.term.name.like("home")) ? "<a class='module' href='/Diary'><img src='img/vectors/diary.svg' class='icon'/>#{@page.diaries.length} Diaries</a>" : ""
      html_header += @page.term && (@page.term.name.like("home")) ? "<a class='module' href='/Horaire'><img src='img/vectors/log.svg' class='icon'/>#{@page.logs.length} Logs</a>" : ""
      html_header += "<content class='source'><img src='img/vectors/source.svg' class='icon'/> \"<a href='/#{@page.diary.topic}:diary#fullscreen'>#{@page.diary.name}</a>\" #{@page.diary.offset}.</content>"
      html_header += "</div></content>"

      # Body

      html_body = "" # {@page.body} #{layoutLinks}

      #

      if @page.links
        html = ""
        @page.links.each do |name,url| 
          link = Link.new(name,url)
          html += link.template
        end
        html_body += "<content class='storage'>"+html+"</content>"
      end

      #
=begin
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
  #{ @page.term || !@page.term.name.like("home") ? "<content class='portal'>#{Media.new("badges",@page.portal,@page.portal).to_html}#{layoutPortalTree}</content>" : ""}
=end
      return "
      <content class='header'>
        #{html_header}
      </content>
      <content class='body'>
        #{html_body}
      </content>
      <content class='footer'>
        <content>
          <dl class='icons'>
            <a href='/Nataniev' class='icon'><img src='/img/interface/icon.oscean.png'/></a>
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

  end

  class PassiveActions

    include ActionCollection

    def answer q = "Home"

      corpse = Corpse.new()
      corpse.add_meta("description","Works of Devine Lu Linvega")
      corpse.add_meta("keywords","aliceffekt, traumae, devine lu linvega")
      corpse.add_meta("viewport","width=device-width, initial-scale=1, maximum-scale=1")
      corpse.add_meta("apple-mobile-web-app-capable","yes")

      corpse.add_link("style.reset.css")
      corpse.add_link("style.main.css")

      corpse.add_script("jquery.core.js")
      corpse.add_script("jquery.main.js")

      corpse.set_title(@target.title)
      corpse.set_body(@target.body)

      return corpse.result

    end

  end
  
  def passive_actions ; return PassiveActions.new(self,self) end

end