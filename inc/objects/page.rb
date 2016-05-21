# encoding: utf-8
#: Missing..

class Page

	def initialize data

		@query   = data["topic"].upcase
	    @module  = data["module"].upcase
	    @lexicon = Lexicon.new(data["lexicon"])
	    @horaire = data["horaire"]
	    @issues  = data["issues"]

	    @term = @lexicon.term(@query)
	    @logs = @horaire.logs(@term)

	    @sector = _sector

	    @diaries = _diaries
	    @diary = _diary
	    
	    @issues = _issues
	    @title = _title
	    @portal = _portal

	    loadModules

	    puts "<div style='background:red; color:white'>Migrating XXIIVV database to Jiin. Things should return to normal shortly.</div>"

	end

	def title

		return @title

	end

	def _title

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
			if log.photo < 1 then next end
			array.push(log)
		end
		return array

	end

	def logs

		return @logs

	end

	def issues

		return @issues

	end

	def _issues

		hash = {}
		@issues.each do |issue|
			if issue.topic != @term.name && @query != "HOME" then next end
			if !hash[issue.release] then hash[issue.release] = [] end
			hash[issue.release].push(issue)
		end
		return hash

	end

	def view

		html = ""

		if @term.bref
			html += "<p>#{@term.bref}</p>"
		end

		if @term.long
			@term.long.each do |line|
				rune = line[0,1]
				text = line.sub(rune,"").strip
				case rune
				when "&"
					html += "<p>#{text}</p>"
				when "-"
					html += "<li>#{text}</li>"
				when "?"
					html += "<small>#{text}</small>"
				else
					html += "[??]#{text}[??]"
				end
			end
		end

		return macros(html)

	end

	def links

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

	    while @lexicon.unde(unde).unde != unde.name
	      if depth > 5 then return unde end
	      if unde.flags.include?("portal") then break end
	      unde = @lexicon.unde(unde)
	      depth += 1
	    end
	    return unde

	end

	def macros text
		
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

		# @term.flags.each do |flag|
		# 	if File.exist?("inc/modules/#{flag}.rb") then require_relative("../modules/#{flag}.rb") end
		# end
	 #    if File.exist?("inc/pages/#{@query}.rb") then require_relative("../pages/#{@query}.rb") end
