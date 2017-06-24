#!/bin/env ruby
# encoding: utf-8

class Term

  attr_accessor :name
  attr_accessor :unde
  attr_accessor :type
  attr_accessor :link
  attr_accessor :bref
  attr_accessor :long
  attr_accessor :logs

  def initialize name = "Unknown", data = {}

    data = data ? data : { "UNDE" => nil, "TYPE" => "Missing" }

    @name = "#{name}".downcase.capitalize
    @unde = data["UNDE"] ? data["UNDE"].downcase.capitalize : "Home"
    @type = data["TYPE"] ? data["TYPE"] : nil
    @tags = data["TAGS"] ? data["TAGS"] : nil
    @link = data["LINK"]
    @bref = data["BREF"] ? data["BREF"].markup : nil
    @long = data["LONG"] ? data["LONG"] : []

    @logs = nil

  end

  def is_module    ; return @module end
  def is_diary     ; return @module == "diary"    ? true : false end
  def is_issue     ; return @module == "issue"    ? true : false end
  def is_horaire   ; return @module == "horaire"  ? true : false end
  def is_photo     ; return @module == "photo"    ? true : false end
  def has_diaries  ; return diaries.length > 0    ? true : false end
  def has_logs     ; return logs.length > 0       ? true : false end
  def has_tag tag  ; return tags.include?(tag)    ? true : false end
  
  def is_type t ; return type && type.like(t) ? true : false end

  def parent

    @parent = @parent ? @parent : @parent = $lexicon.filter("term",unde,"term")
    return @parent

  end

  def children

    if @children then return @children end

    a = []
    $lexicon.to_h("term").each do |t_name,t_term|
      if !t_term.unde.like(name) then next end
      a.push(t_term)
    end
    @children = a
    return a

  end

  def siblings

    if @siblings then return @siblings end
      
    a = []
    $lexicon.to_h("term").each do |name,term|
      if !term.unde then next end
      if !term.unde.like(unde) then next end
      a.push(term)
    end
    @siblings = a
    return a

  end

  def type_value

    if !@type then return nil end
    if !@type.include?(" ") then return nil end
    return @type.split(" ").last.strip.downcase.to_sym

  end

  def type

    if !@type then return nil end
    return @type.split(" ").first.downcase.capitalize

  end

  def comments
    
    @comments = @comments ? @comments : ( name.like("home") || name.like("forum") ) ? $forum.to_a : $forum.filter("topic",name,"comment")
    return @comments

  end

  def tasks

    if @tasks then return @tasks end

    @tasks = {}
    logs.each do |log|
      if !@tasks[log.task] then @tasks[log.task] = {"name" => log.task, :sum_hours => 0, :sum_logs => 0, :audio => 0, :visual => 0, :research => 0, :misc => 0, :topics => []} end
      @tasks[log.task][log.sector] += log.value
      @tasks[log.task][:sum_logs] += 1
      @tasks[log.task][:sum_hours] += log.value
      @tasks[log.task][:topics].push(log.topic)
    end
    return @tasks

  end

  # Dynamo

  def logs

    @logs = @logs ? @logs : ( name.like("home") || name.like("diary") ? $horaire.filter("term","*","log") : $horaire.filter("term",name,"log"))
    return @logs

  end

  def tags

    dynamic_tags = []
    if @long.length < 2 then dynamic_tags.push("stub") end
    if @unde.like("home") || @unde.like(@name) then dynamic_tags.push("root") end
    return @tags ? @tags.to_s.downcase.split(" ") + dynamic_tags : dynamic_tags

  end

  def diaries

    if @diaries then return @diaries end

    @diaries = []
    logs.each do |log|
      if log.photo < 1 then next end
      @diaries.push(log)
    end
    return @diaries

  end

  def diary

    if @diary then return @diary end
    if diaries.length < 1 then return nil end

    @diary = diaries.first

    diaries.each do |log|
      if log.is_featured && @name.like("home") || log.is_highlight && !@name.like("home")
        @diary = log
        break
      end
    end
    return @diary

  end

  def portal

    depth = 0
    t = self

    while !t.parent.name.like(self.name)
      if depth > 5 then return "nataniev" end
      if t.is_type("Portal") then t = t ; break end
      t = t.parent
      depth += 1
    end
    return t ? t.name : "nataniev"

  end

  def badge

    if Media.new("badge",name).exists
      b = Media.new("badge",name)
    elsif Media.new("badge",unde).exists
      b = Media.new("badge",unde)
    elsif Media.new("badge",type).exists
      b = Media.new("badge",type)
    elsif Media.new("badge",parent.name).exists
      b = Media.new("badge",parent.name)
    elsif Media.new("badge",parent.parent.name).exists
      b = Media.new("badge",parent.parent.name)
    else
      b = Media.new("badge","nataniev")
    end
    b.set_class("portal")
    return b

  end

  def theme

    return diaries.length < 1 ? "default" : diaries.first.theme

  end

  def to_s full = nil, display_photo = true

    return "
    <yu>
      #{display_photo == true && diary ? "<a href='/#{name}'>"+diary.media.to_s+"</a>" : ""}
      <h2><a href='/#{name}'>#{name}</a></h2>
      <p>#{bref}</p>
      #{full == :long ? @long.runes : ""}
    </yu>"

  end

  def to_h

    return {
      :name => @name,
      :unde => @unde,
      :type => @type,
      :tags => @tags,
      :bref => @bref,
      :long => @long,
      :photo => diary.photo
    }

  end

end
