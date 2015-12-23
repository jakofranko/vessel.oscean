#!/bin/env ruby
# encoding: utf-8

class Layouts

	def debug

		@topics = {}
		@diaries = fetch_diaries
		@lexicon = fetch_lexicon
		@imagesDiary = fetch_imagesDiary
		@imagesLexicon = fetch_imagesLexicon
		@usedImages = []

		@imagesIssues = []

		find_validateMacros
		find_missingMacros
		find_unusedImages

		return print_result

	end

	def print_result

		html = "<pre>"
		@diaries.sort.each do |date,diary|
			if diary["macros"].length == 0 then next end
			html += "#{date}(#{diary["macros"].length} macros)<br />"
			diary["macros"].each do |macro|
				html += macro
			end
		end
		@lexicon.each do |topic,term|
			if term["macros"].length == 0 then next end
			html += "#{topic}(#{term["macros"].length} macros)<br />"
			term["macros"].each do |macro|
				html += macro
			end
		end
		@imagesIssues.each do |name,issue|
			html += "#{name}<br />  <span style='color:red'>#{issue}</span><br />"
		end
		html += "</pre>"
		return html

	end

	def fetch_diaries

		hash = {}
		query = $quest.query("SELECT date,topic,photo,full FROM XIV_Horaire WHERE full !='' OR photo > 0 ") 
	    while row = query.fetch_row do
	    	hash["#{row[0]}"] = {"topic"=>row[1],"photo"=>row[2],"full"=>row[3].force_encoding("utf-8"),"macros"=>[]}
	    end
	    return hash

	end

	def fetch_lexicon

		hash = {}
		query = $quest.query("SELECT term,definition FROM XIV_Lexicon") 
	    while row = query.fetch_row do
	    	hash["#{row[0]}"] = {"definition"=>row[1].to_s.force_encoding("utf-8"),"macros"=>[]}
	    end
	    return hash

	end

	def fetch_imagesDiary

		@imagesDiary = []
		Dir.entries("./content/diary").sort.each do |fileName,v|
	    	@imagesDiary.push( {"name" => fileName, "issues" => []} )
	    end

    end

	def fetch_imagesLexicon

		@imagesLexicon = {}
		Dir.entries("./content/lexicon").sort.each do |fileName,v|
	    	@imagesLexicon[fileName.to_s] = {}
	    	@imagesLexicon[fileName.to_s]["issues"] = []
	    end

    end

	def find_validateMacros

		@diaries.each do |date,diary|
			macros = diary["full"].scan(/(?:\{\{)([\w\W]*?)(?=\}\})/)
	    	if macros.length == 0 then next end
	    	macros.each do |macro|
	    		if validateMacros(date,diary,macro.first) then @diaries[date]["macros"].push(validateMacros(date,diary,macro.first)) end
	    	end
		end

	end

	def validateMacros date,diary, macro

		if macro[0,6] == "diary:" then return macro_diaryImage(date,diary, macro) end
		if macro[0,8] == "lexicon:" then return macro_lexiconImage(date,diary, macro) end

	end

	def macro_diaryImage date,diary, macro

		@usedImages.push("#{diary['photo']}.#{macro.gsub("diary:","")}")
		if !File.exist?("content/diary/#{diary['photo']}."+macro.gsub("diary:","")+".jpg")
			return "  #{macro} <span style='color:red'>Missing image: <b>#{diary['photo']}."+macro.gsub("diary:","")+".jpg</b></span><br />"
		end

	end

	def macro_lexiconImage date,diary, macro

		if !File.exist?("content/lexicon/#{diary['photo']}."+macro.gsub("lexicon:","")+".jpg")
			return "  #{macro} <span style='color:red'>Missing image: <b>#{diary['photo']}."+macro.gsub("lexicon:","")+".jpg</b></span><br />"
		end

	end

	def find_missingMacros

		@diaries.each do |date,diary|
			if diary["full"].to_s.include?("<img ") then @diaries[date]["macros"].push("  <span style='color:red'>Untemplated image</span><br />") end
			if diary["full"].to_s.include?("<a ") then @diaries[date]["macros"].push("  <span style='color:red'>Untemplated link</span><br />") end
		end
		@lexicon.each do |topic,definition|
			if definition.to_s.include?("<img ") then @lexicon[topic]["macros"].push("  <span style='color:red'>Untemplated image</span><br />") end
			if definition.to_s.include?("<a ") then @lexicon[topic]["macros"].push("  <span style='color:red'>Untemplated link</span><br />") end
		end

	end

	def find_unusedImages

		# Find used images
		@diaries.each do |date,diary|
			@usedImages.push(diary["photo"])
		end

		@imagesDiary.each do |name,issues|
			if name.include?("_") then @imagesIssues.push([name,"Invalid name: Includes _"]) end
			if name[0,1] == "0" then @imagesIssues.push([name,"Invalid name: Start with 0"]) end
			if !@usedImages.include?(name.gsub(".jpg","")) then @imagesIssues.push([name,"Unsused Image"]) end
		end

		@imagesLexicon.each do |name,issues|
			if !@usedImages.include?(name.gsub(".jpg","")) then @imagesIssues.push([name,"Unsused Image"]) end
		end

	end

end