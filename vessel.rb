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

    def body q = "Home"

      page   = Page.new(q.include?(":") ? q.split(":") : q)

      return "
<yu class='hd'>
  <wr>
    <a href='/' class='lg'><img src='img/vectors/logo.svg'/></a>
    #{!page.is_diary   && page.has_diaries ? "<a class='md' href='/Diary'><img src='img/vectors/diary.svg'/>#{page.diaries.length} Diaries</a>" : ""}
    #{!page.is_horaire && page.has_logs    ? "<a class='md' href='/Horaire'><img src='img/vectors/log.svg'/>#{page.logs.length} Logs</a>" : ""}
    <input placeholder='#{page.term.name}' class='q'/>
    #{page.diary ? "<a href='/#{page.diary.topic}:diary#fullscreen' class='md'><img src='img/vectors/source.svg' class='icon'/> \"#{page.diary.name}\" #{page.diary.offset}</a>" : ""}
  </wr>
  #{page.diary ? Media.new("diary",page.diary.photo).to_html : ""}
</yu>
<yu class='cr'>
  #{page.body}
</yu>
<yu class='ft'>
  <wr>
    <ln><a href='/Nataniev'><img src='/img/interface/icon.oscean.png'/></a><a href='https://github.com/neauoire' target='_blank'><img src='img/interface/icon.github.png'/></a><a href='https://twitter.com/neauoire' target='_blank'><img src='img/interface/icon.twitter.png'/></a></ln>
    <ln><a href='/Devine+Lu+Linvega'><b>Devine Lu Linvega</b></a> © 2009-#{Time.now.year} <a href='http://creativecommons.org/licenses/by-nc-sa/4.0/' target='_blank' style='color:#aaa'>BY-NC-SA 4.0</a></ln>
    <ln>Currently indexing #{page.lexicon.all.length} projects, built over #{page.horaire.length} days.</ln>
    <ln><a href='/Diary'>Diary</a> &bull; <a href='/Horaire'>Horaire</a> &bull; <a href='/Desamber' class='date'>"+Desamber.new().default+"</a><br /><a href='Clock'>"+Clock.new().default+"</a> "+((Time.new - $timeStart) * 1000).to_i.to_s+"ms</ln>
  </wr>
</yu>"

    end

  end

  class PassiveActions

    include ActionCollection

    def answer q = "Home"

      corpse = Corpse.new(q)
      corpse.add_meta("description","Works of Devine Lu Linvega")
      corpse.add_meta("keywords","aliceffekt, traumae, devine lu linvega")
      corpse.add_meta("viewport","width=device-width, initial-scale=1, maximum-scale=1")
      corpse.add_meta("apple-mobile-web-app-capable","yes")

      corpse.add_link("style.reset.css")
      corpse.add_link("style.main.css")

      corpse.add_script("jquery.core.js")
      corpse.add_script("jquery.main.js")

      corpse.set_title("XXIIVV ∴ #{q}")

      return corpse.result

    end

  end
  
  def passive_actions ; return PassiveActions.new(self,self) end

end