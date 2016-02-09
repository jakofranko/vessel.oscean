class Aeth

	def initialize hash = nil

		if hash then push(hash) end
		@entries = []

	end

	def english

		return @entries.first['english']

	end

	def traumae

		return @entries.first['traumae']

	end

	def adultspeak

		if traumae.include?("'") then return traumae end

		c1 = traumae[0,1]
		c2 = traumae[2,1]
		c3 = traumae[4,1]
		v1 = traumae[1,1]
		v2 = traumae[3,1]
		v3 = traumae[5,1]

		if c1 == c2 then c2 = "" end
		if v1 == v2 then v2 = "" end

		if c2 == c3 then c3 = "" end
		if v2 == v3 then v3 = "" end

		assembled = "#{c1}#{v1}#{c2}#{v2}#{v3}#{c3}"
		
		return assembled

	end

	def push hash

		@entries.push(hash)

	end

end