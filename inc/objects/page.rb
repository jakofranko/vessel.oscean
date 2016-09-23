# encoding: utf-8

class Page

	def initialize q

		@query   = q.class == Array ? q.first.gsub("+"," ") : q.gsub("+"," ") 
    @module  = q.class == Array ? q.last : nil

    @lexicon = Lexicon.new(En.new("lexicon").to_h)
    @horaire = Horaire.new(Di.new("horaire").to_a)    

    $lexicon = @lexicon
    $horaire = @horaire

    loadModules

	end

	def title

		return term.name

	end

  def lexicon

    return @lexicon
    
  end

  def horaire

    return @lexicon
    
  end

	def is_diary

		if @module == "diary" then return true end
		return false

	end

	def is_horaire

		if @module == "horaire" then return true end
		return false

	end

	def term

		if @term then return @term end
		@term = @lexicon.term(@query)
		return @term

	end

	# Horaire

	def logs

		if @logs then return @logs end
		@logs = @horaire.logs(@term.name)
		return @logs

	end

	def has_diaries

		return diaries.length > 0 ? true : false
		
	end

	def has_logs

		return logs.length > 0 ? true : false
		
	end

	def diary

		if @diary then return @diary end
    if diaries.length < 1 then return nil end

		@diary = diaries.first

		diaries.each do |log|
			if log.isFeatured
				@diary = log
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

	# OLD

	def body

		return "<wr>"+macros("<p>#{term.bref.to_s}</p>#{term.long.to_s}")+"</wr>"

	end

	def links

		if @links then return @links end
		@links = term.link
		return @links

	end

	def portal

		return "None"
    # depth = 0
    # unde = @lexicon.unde(@term)
    
    # if unde == nil then return Term.new() end

    # while @lexicon.unde(unde) && @lexicon.unde(unde).unde != unde.name
    #   if depth > 5 then return unde end
    #   if unde.type && unde.type.like("portal") then break end
    #   unde = @lexicon.unde(unde)
    #   depth += 1
    # end
    # return unde

	end

	def macros text
		
		if !text then return "" end
			
		search = text.scan(/(?:\{\{)([\w\W]*?)(?=\}\})/)
    search.each do |str,details|
        text = text.gsub("{{"+str+"}}",parser(str))
    end
    text = text.gsub("{_","<i>").gsub("_}","</i>")
    text = text.gsub("{*","<b>").gsub("*}","</b>")
    return text

	end

	def parser macro

		if macro == "!clock" then return "<a href='/Clock'>#{Clock.new().default}</a>" end
		if macro == "!desamber" then return "<a href='/Desamber'>#{Desamber.new().default}</a>" end
			
		if macro.like(@query) then return "<b>#{macro}</b>" end
		if macro.include?("|")
			if macro.split("|")[1].include?("http") then return "<a href='"+macro.split("|")[1]+"' class='external'>"+macro.split("|")[0]+"</a>"
			else return @lexicon.find(macro.split("|")[1]) ? "<a href='"+macro.split("|")[1]+"'>"+macro.split("|")[0]+"</a>" : "<a class='dead' href='"+macro.split("|")[1]+"'>"+macro.split("|")[0]+"</a>" end
		end
    return @lexicon.find(macro) ? "<a href='"+macro.gsub(" ","+")+"'>#{macro}</a>" : "<a class='dead' href='"+macro.gsub(" ","+")+"'>#{macro}</a>"

	end

	def loadModules

		if term.name.like("Unknown") then require_relative("../pages/missing.rb") ; return end
		if File.exist?("#{$nataniev_path}/instances/instance.oscea/inc/pages/#{@query.downcase}.rb") then require_relative("../pages/#{@query.downcase}.rb") end
		if File.exist?("#{$nataniev_path}/instances/instance.oscea/inc/modules/#{@query.downcase}.rb") then require_relative("../modules/#{@query.downcase}.rb") end
		if @term.type && File.exist?("#{$nataniev_path}/instances/instance.oscea/inc/modules/#{@term.type.downcase}.rb") then require_relative("../modules/#{@term.type.downcase}.rb") end
		if @module && File.exist?("#{$nataniev_path}/instances/instance.oscea/inc/modules/#{@module.downcase}.rb") then require_relative("../modules/#{@module.downcase}.rb") end

	end

  # Inline Style

  def view q = "Home"

    return "
<yu class='hd'>
  <wr>
    <a href='/' class='lg'><img src='img/vectors/logo.svg'/></a>
    #{!is_diary   && has_diaries ? "<a class='md' href='/Diary'><img src='img/vectors/diary.svg'/>#{diaries.length} Diaries</a>" : ""}
    #{!is_horaire && has_logs    ? "<a class='md' href='/Horaire'><img src='img/vectors/log.svg'/>#{logs.length} Logs</a>" : ""}
    <input placeholder='#{term.name}' class='q'/>
    #{diary ? "<a href='/#{diary.topic}:diary#fullscreen' class='md li'>#{diary.name}<img src='img/vectors/source.svg'/></a>" : ""}
  </wr>
  #{diary ? Media.new("diary",diary.photo).to_html : ""}
</yu>
<yu class='cr'>
  #{body}
</yu>
<yu class='ft'>
  <wr>
    <ln><a href='/Nataniev'><img src='/img/interface/icon.oscean.png'/></a><a href='https://github.com/neauoire' target='_blank'><img src='img/interface/icon.github.png'/></a><a href='https://twitter.com/neauoire' target='_blank'><img src='img/interface/icon.twitter.png'/></a></ln>
    <ln><a href='/Devine+Lu+Linvega'><b>Devine Lu Linvega</b></a> © 2009-#{Time.now.year} <a href='http://creativecommons.org/licenses/by-nc-sa/4.0/' target='_blank' style='color:#aaa'>BY-NC-SA 4.0</a></ln>
    <ln>Currently indexing #{lexicon.all.length} projects, built over #{horaire.length} days.</ln>
    <ln><a href='/Diary'>Diary</a> &bull; <a href='/Horaire'>Horaire</a> &bull; <a href='/Desamber' class='date'>"+Desamber.new().default+"</a><br /><a href='Clock'>"+Clock.new().default+"</a> "+((Time.new - $timeStart) * 1000).to_i.to_s+"ms</ln>
  </wr>
</yu>"

  end

  def add_style k,v

    styles.push([k,v])

  end

  def styles

    @styles = !@styles ? [] : @styles
    return @styles

  end

  def style

    css = ""
    styles.each do |k,v|
      css += "#{k} {#{v}} "
    end

    return css

  end

end