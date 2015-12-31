# encoding: utf-8
#: {{Horaire}} is a Hash extension with filtering tools to look up Logs quickly.
class Horaire

	def initialize(db_horaire)
		@db_horaire = db_horaire
	end

	def logOnDate year,month,day

		dateFormat = "#{year}-#{month.to_s.rjust(2, '0')}-#{day.to_s.rjust(2, '0')}"

		if @db_horaire[dateFormat] then return @db_horaire[dateFormat] end
		return

	end

	def all
		return @db_horaire.sort.reverse
	end

	def length
		return @db_horaire.length
	end

	# Lookups

	def diaries

		result = []
		all.each do |date,log|
			if log.photo < 1 then next end
			result.push(log)
		end
		return result

	end

	def photo

		all.each do |date,log|
			if log.photo < 1 then next end
			if log.isFeatured == false then next end
			return log.photo
		end

	end

	def hours

		result = 0
		all.each do |date,log|
			result += log.value
		end
		return result

	end

	# Search

	def diaryWithId target

		all.each do |date,log|
			if log.photo < 1 then next end
			if log.photo != target.to_i then next end
			return log
		end

		return nil

	end

end