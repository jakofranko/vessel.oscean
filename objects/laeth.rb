# encoding: utf-8
#: The {{Laeth}} object wraps around {{Traumae}} constructs, allowing for translation and conversion(Adultspeak).

class Laeth

	def initialize(data)

    	@id = data["id"]
    	@traumae = data["traumae"]
    	@english = data["english"]
    	@rank = data["rank"]
    	@info = data["info"]
    	
	end

    def traumae
    	return @traumae
    end

    def english
    	return @english
    end

    def rank
    	return @rank
    end

	def adultspeak

		childspeak = @traumae

	    if childspeak.include? " " then return childspeak end
	    if childspeak.length < 3 then return childspeak end

	    # Isolates the pieces
	    consonants = []
	    vowels = []
	    letters = []
	    i = 0
	    childspeak.split(//).each do |k,v|
	        if i % 2 == 0 then consonants.push(k)
	        else vowels.push(k) end
	        letters.push(k)
	        i += 1
	    end

	    adultspeak = childspeak

	    # Parse(Only works with 4 or 6 characters)
	    if consonants[0] == consonants[1]
	        letters[2] = ""
	    elsif consonants[1] == consonants[2]
	        letters[4] = ""
	    end
	    if vowels[0] == vowels[1]
	        letters[1] = ""
	    elsif vowels[1] == vowels[2]
	        letters[3] = ""
	    end

	    # Recreate word
	    adultspeak = ""
	    letters.each do |k,v|
	        adultspeak += k
	    end

	    # Invert last 2 letters
	    if consonants.count(adultspeak[-2,1]) > 0
	        segment1 = adultspeak[0..-3]
	        segment2 = adultspeak[-2,3]
	        adultspeak = segment1+segment2.reverse
	    end

	    # Merge dups
	    adultspeak = adultspeak.gsub("aa","a")
	    adultspeak = adultspeak.gsub("ii","i")
	    adultspeak = adultspeak.gsub("oo","o")

	    # Experiment
	    # adultspeak = adultspeak.gsub("ia","e")
	    # adultspeak = adultspeak.gsub("ao","u")
	    # adultspeak = adultspeak.gsub("oi","y")

	    return adultspeak

	end

end