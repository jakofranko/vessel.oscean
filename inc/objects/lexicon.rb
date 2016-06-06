# encoding: utf-8

class Lexicon

	def initialize(db_lexicon)

		@db_lexicon = {}
		db_lexicon.each do |name,content|
			@db_lexicon[name] = Term.new(name,content)
		end

	end

	def all
		return @db_lexicon.sort
	end
	
	def length
		return @db_lexicon.length
	end

	def term target
		if @db_lexicon[target.upcase] then return @db_lexicon[target.upcase] end
		return nil
	end

	def definition term
		if !@db_lexicon[term] then return "" end
		return @db_lexicon[term]["definition"]
	end

	def find term
		if @db_lexicon[term.upcase] then return Term.new(@db_lexicon[term.upcase]) end
		return
	end

	def flags term
		if !@db_lexicon[term] then return end
		return @db_lexicon[term]["flags"]
	end

	def isFlagged term, flag
		if !@db_lexicon[term] then return false end
		if @db_lexicon[term]["flags"].include? flag
		  return 1
		end
	end

	def unde term
		if term == nil then return nil end
		if !@db_lexicon[term.unde.upcase] then return nil end
		return @db_lexicon[term.unde.upcase]
	end

	def siblings target
		array = []
		@db_lexicon.each do |index,term|
			if term.unde != target.unde then next end
			array.push(term)
		end
		return array
	end

	def children target
		array = []
		@db_lexicon.each do |index,term|
			if term.unde != target.name then next end
			array.push(term)
		end
		return array
	end

	def storage term
		if !@db_lexicon[term] then return end
		return @db_lexicon[term]["storage"]
	end

end