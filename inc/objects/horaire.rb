# encoding: utf-8

class Horaire

	def initialize(db_horaire)
		
		@db_horaire = {}
		db_horaire.each do |date,content|
			@db_horaire[date] = Log.new(date,content)
		end

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

	def logs term

		array = []
		all.each do |date,log|
			if log.topic.like(term.name) || term.name.like("home") then array.push(log) end
		end
		return array

	end

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

		diaries.each do |log|
			if log.photo != target.to_i then next end
			return log
		end

		return nil

	end

	# Search

	def featuredDiaryWithTopic target

		diaries.each do |log|
			if log.topic.downcase != target.downcase then next end
			return log
		end
		return nil

	end

end