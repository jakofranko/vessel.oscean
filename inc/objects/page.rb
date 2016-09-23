# encoding: utf-8

class Page

	def initialize data

		@query   = data["topic"].upcase
    @module  = data["module"].upcase

    @lexicon = Lexicon.new(data["lexicon"])
    @horaire = Horaire.new(data["horaire"])

    @term = @lexicon.term(@query)
    @logs = @horaire.logs(@term.name)

    @sector = _sector
    @diaries = _diaries
    @diary = _diary
    @title = _title
    @portal = _portal

    $lexicon = @lexicon
    $horaire = @horaire

    loadModules

	end

	def title

		return @title

	end

	def _title

		if !@term then return @query.capitalize end
		return @term.name.downcase.capitalize

	end

	def sector

		return @sector

	end

	def _sector

		return "audio"

	end

	def term

		return @term

	end

	# Horaire

	def diary

		return @diary

	end

	def _diary

		@diaries.each do |log|
			if log.isFeatured then return log end
		end
		return @diaries.first

	end

	def diaries

		return @diaries

	end

	def _diaries

		array = []
		@logs.each do |log|
			if log.photo < 1 && log.full.to_s == "" then next end
			array.push(log)
		end
		return array

	end

	def logs

		return @logs

	end

	def body

		return macros("<p>#{@term.bref.to_s}</p>#{@term.long.to_s}")

	end

	def links

		if !@term then return end
		return @term.link

	end

	def module

		return @module

	end

	def lexicon

		return @lexicon

	end

	def horaire

		return @horaire

	end

	def isDiary

		return @query.to_i > 0 ? true : false

	end

	def isTerm

		return @term ? true : false

	end

	def portal

		return @portal

	end

	def _portal

	    depth = 0
	    unde = @lexicon.unde(@term)
	    
	    if unde == nil then return Term.new() end

	    while @lexicon.unde(unde) && @lexicon.unde(unde).unde != unde.name
	      if depth > 5 then return unde end
	      if unde.type && unde.type.like("portal") then break end
	      unde = @lexicon.unde(unde)
	      depth += 1
	    end
	    return unde

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

		if @term.name.like("Unknown") then require_relative("../pages/missing.rb") ; return end
		if File.exist?("#{$nataniev_path}/instances/instance.oscea/inc/pages/#{@query.downcase}.rb") then require_relative("../pages/#{@query.downcase}.rb") end
		if File.exist?("#{$nataniev_path}/instances/instance.oscea/inc/modules/#{@query.downcase}.rb") then require_relative("../modules/#{@query.downcase}.rb") end
		if @term.type && File.exist?("#{$nataniev_path}/instances/instance.oscea/inc/modules/#{@term.type.downcase}.rb") then require_relative("../modules/#{@term.type.downcase}.rb") end
		if @module && File.exist?("#{$nataniev_path}/instances/instance.oscea/inc/modules/#{@module.downcase}.rb") then require_relative("../modules/#{@module.downcase}.rb") end

	end

end