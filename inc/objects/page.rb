# encoding: utf-8

class Page

	def initialize query

		@query   = query
    @module  = query != @query ? query.last : nil

    @lexicon = Lexicon.new(En.new("lexicon").to_h)
    @horaire = Horaire.new(Di.new("horaire").to_a)    

    $lexicon = @lexicon
    $horaire = @horaire

    loadModules

	end

	def title

		return term.name

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

		@diary = @diaries.first

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

		return macros("<p>#{term.bref.to_s}</p>#{term.long.to_s}")

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

end