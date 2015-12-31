# encoding: utf-8
#: {{Horaire}} is a Hash extension with filtering tools to look up Terms quickly.

class Lexicon

	def initialize(db_lexicon)
		@db_lexicon = db_lexicon
	end

	def all
		return @db_lexicon.sort
	end
	
	def length
		return @db_lexicon.length
	end

	def term target
		target = target.capitalize
		if @db_lexicon[target] then return @db_lexicon[target] end
		return Term.new({ 'term' => "Missing", 'parent' => "Home", 'flags' => "", 'storage' => "", 'definition' => ""})
	end

	def definition term
		if !@db_lexicon[term] then return "" end
		return @db_lexicon[term]["definition"]
	end

	def find term
		term = term.to_s.downcase.capitalize
		if @db_lexicon[term] then return @db_lexicon[term] end
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

	def parent term
		if !@db_lexicon[term] then return "" end
		return @db_lexicon[term].parent
	end

	def storage term
		if !@db_lexicon[term] then return end
		return @db_lexicon[term]["storage"]
	end

end