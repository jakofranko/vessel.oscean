# encoding: utf-8
#: Missing..

class Page

	def initialize data

		@query   = data["topic"].downcase
	    @module  = data["module"].downcase
	    @lexicon = data["lexicon"]
	    @horaire = data["horaire"]
	    @issues  = data["issues"]

	    @sector = _sector
	    @term = _term
	    @diaries = _diaries
	    @diary = _diary
	    @logs = _logs
	    @issues = _issues
	    @title = _title
	    @body = _body
	    @portal = _portal

	    loadModules

	end

	def title

		return @title

	end

	def _title

		if isDiary then return @diary.title end
		if isTerm then return @term.topic end
		return "Missing"

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

	def _term

		if @query.to_i > 0 then return @lexicon.term(@horaire.diaryWithId(@query).topic) end
		return @lexicon.term(@query)

	end

	def diary

		return @diary

	end

	def _diary

		if @horaire.diaryWithId(@query) then return @horaire.diaryWithId(@query) end
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
		@horaire.all.each do |date,log|
			if log.topic != @term.topic && @query != "home" && @query != "diary" then next end
			if log.photo < 1 then next end
			array.push(log)
		end
		return array

	end

	def logs

		return @logs

	end

	def _logs

		array = []
		@horaire.all.each do |date,log|
			if log.topic != @term.topic && @query != "home" then next end
			array.push(log)
		end
		return array

	end

	def issues

		return @issues

	end

	def _issues

		hash = {}
		@issues.each do |issue|
			if issue.topic != @term.topic && @query != "home" then next end
			if !hash[issue.release] then hash[issue.release] = [] end
			hash[issue.release].push(issue)
		end
		return hash

	end

	def view

		if isDiary then return macros(@diary.full) end
		return body

	end

	def body
		return macros(@body)
	end

	def _body

		if @term.definition.to_s != "" then return @term.definition end

		require_relative("../modules/missing.rb")
	    return missing

	end

	def links

		return @term.storage

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
	    parent = @lexicon.parent(@term)
	    while @lexicon.parent(parent).parent != parent.topic
	      if depth > 5 then return parent end
	      if parent.flags.include?("portal") then break end
	      parent = @lexicon.parent(parent)
	      depth += 1
	    end
	    return parent

	end

	def macros text
		
		search = text.scan(/(?:\{\{)([\w\W]*?)(?=\}\})/)
        search.each do |str,details|
            text = text.gsub("{{"+str+"}}",parser(str))
        end
        return text

	end

	def parser macro

		if macro == "!clock" then return "<a href='/Clock'>#{Clock.new().default}</a>" end
		if macro == "!desamber" then return "<a href='/Desamber'>#{Desamber.new().default}</a>" end
			
		if macro.downcase == @query then return "<b>#{macro}</b>" end
		if macro.include?("|") then return "<a href='"+macro.split("|")[1]+"'>"+macro.split("|")[0]+"</a>" end
        return "<a href='"+macro.gsub(" ","+")+"'>"+macro+"</a>"

	end

	def loadModules

		@term.flags.each do |flag|
			if File.exist?("inc/modules/#{flag}.rb") then require_relative("../modules/#{flag}.rb") end
		end
	    if File.exist?("inc/pages/#{@query}.rb") then require_relative("../pages/#{@query}.rb") end
		if File.exist?("inc/modules/#{@query}.rb") then require_relative("../modules/#{@query}.rb") end
	    if File.exist?("inc/modules/#{@module}.rb") then require_relative("../modules/#{@module}.rb") end

	end

end