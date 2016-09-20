#!/bin/env ruby
# encoding: utf-8

$vessel_path = File.expand_path(File.join(File.dirname(__FILE__), "/"))

$timeStart = Time.new

Dir["#{$vessel_path}/inc/objects/*"].each do |file_name|
  load(file_name)
end

class Oscea

  class Corpse

    include CorpseHttp

  end

  class Actions

    include ActionCollection

    def http q = "Home"

      # Holy hell, what is this mess!?

      @query = q != "" ? q.gsub("+"," ").split(":").first : "Home"
      @module = q.include?(":") ? q.gsub("+"," ").split(":").last : ""

      @data = {
        "topic"   => @query,
        "module"  => @module,
        "lexicon" => En.new("lexicon").to_h,
        "horaire" => Di.new("horaire").to_a
      }

      @page   = Page.new(@data)
      @layout = Layout.new(@page)

      $photo = @page.diary ? @page.diary.photo : nil

      # Corpse
      
      corpse = Corpse.new
      
      corpse.add_meta("description","Works of Devine Lu Linvega")
      corpse.add_meta("keywords","aliceffekt, traumae, ikaruga, devine lu linvega")
      corpse.add_meta("viewport","width=device-width, initial-scale=1, maximum-scale=1")
      corpse.add_meta("apple-mobile-web-app-capable","yes")

      corpse.add_link("style.reset.css")
      corpse.add_link("style.main.css")

      corpse.add_script("jquery.core.js")
      corpse.add_script("jquery.main.js")

      corpse.set_title(@layout.title)
      corpse.set_body(@layout.view)

      return corpse.result

    end

  end
  
  def actions ; return Actions.new(self,self) end

end