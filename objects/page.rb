#!/bin/env ruby
# encoding: utf-8

class Page

  def initialize q

    @query   = q.class == Array ? q.first.gsub("+"," ") : q.gsub("+"," ") 
    @module  = q.class == Array ? q.last : nil

  end

  def start

    $lexicon = Lexicon.new(En.new("lexicon",path).to_h)
    $horaire = Horaire.new(Di.new("horaire",path).to_a)

    loadModules

  end

  attr_accessor :path

  def title

    return term.name

  end

  def is_diary     ; return @module == "diary"    ? true : false end
  def is_horaire   ; return @module == "horaire"  ? true : false end
  def has_diaries  ; return diaries.length > 0    ? true : false end
  def has_logs     ; return logs.length > 0       ? true : false end

  def term

    if @term then return @term end
    @term = $lexicon.term(@query)
    return @term

  end

  # Horaire

  def logs

    if @logs then return @logs end
    @logs = $horaire.logs(@term.name)
    return @logs

  end

  def diary

    if @diary then return @diary end
    if diaries.length < 1 then return nil end

    @diary = diaries.first

    diaries.each do |log|
      if log.isFeatured
        @diary = log
        break
      end
    end
    
    return @diary

  end

  def diaries

    if @diaries then return @diaries end

    @diaries = []
    logs.each do |log|
      if log.photo < 1 && log.full.to_s == "" then next end
      @diaries.push(log)
    end
    return @diaries

  end

  # HTML

  def body

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

  def loadModules

    if term.name.like("Unknown") then require_relative("../pages/missing.rb") ; return end
    if File.exist?("#{path}/pages/#{@query.downcase}.rb") then require_relative("../pages/#{@query.downcase}.rb") end
    if File.exist?("#{path}/modules/#{@query.downcase}.rb") then require_relative("../modules/#{@query.downcase}.rb") end
    if @term.type && File.exist?("#{path}/modules/#{@term.type.downcase}.rb") then require_relative("../modules/#{@term.type.downcase}.rb") end
    if @module && File.exist?("#{path}/modules/#{@module.downcase}.rb") then require_relative("../modules/#{@module.downcase}.rb") end

  end

  # Inline Style

  def view q = "Home"

    return "
<yu class='hd'>
  <wr>
    <a href='/' class='lg'><img src='img/vectors/logo.svg'/></a>
    #{!is_diary   && has_diaries ? "<a class='md' href='/#{term.name}:diary'><img src='img/vectors/diary.svg'/>#{diaries.length} Diaries</a>" : ""}
    #{!is_horaire && has_logs    ? "<a class='md' href='/#{term.name}:horaire'><img src='img/vectors/log.svg'/>#{logs.length} Logs</a>" : ""}
    <input placeholder='#{term.name}' class='q'/>
    #{diary ? "<a href='/#{diary.photo}' class='md li'><img src='img/vectors/source.svg'/></a>" : ""}
  </wr>
  #{diary ? Media.new("diary",diary.photo) : ""}
</yu>
<yu class='cr'>
  #{body}
  #{links}
</yu>
<yu class='ft'>
  <wr>
    <a href='/#{term.portal}'>#{ badge = Media.new("badge",term.name) ; badge.exists ? badge : badge = Media.new("badge",term.portal) ; badge.exists ? badge : badge = Media.new("badge","nataniev") ; badge }</a>
    <ln><a href='/Nataniev'>#{Media.new("interface","icon.oscean")}</a><a href='https://github.com/neauoire' target='_blank'>#{Media.new("interface","icon.github")}</a><a href='https://twitter.com/neauoire' target='_blank'>#{Media.new("interface","icon.twitter")}</a></ln>
    <ln><a href='/Devine+Lu+Linvega'><b>Devine Lu Linvega</b></a> © 2009-#{Time.now.year} <a href='http://creativecommons.org/licenses/by-nc-sa/4.0/' target='_blank' style='color:#aaa'>BY-NC-SA 4.0</a></ln>
    <ln>Currently indexing #{$lexicon.all.length} projects, built over #{$horaire.length} days.</ln>
    <ln><a href='/Diary'>Diary</a> &bull; <a href='/Horaire'>Horaire</a> &bull; <a href='/Desamber' class='date'>#{Desamber.new}</a><br /><a href='Clock'>#{Clock.new}</a> "+((Time.new - $nataniev.time) * 1000).to_i.to_s+"ms</ln>
  </wr>
</yu>"

  end

  def style

    css = ""
    styles.each do |k,v|
      css += "#{k} {#{v}} "
    end

    return css

  end

  def styles

    @styles = !@styles ? [] : @styles
    return @styles

  end

  def add_style k,v

    styles.push([k,v])

  end

end