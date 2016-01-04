# encoding: utf-8
#: {{Clock}} is a time system that simply divides the elapsed day into percentages. Clock.new().default

require 'date'

class Clock

	def initialize()
		@time = Time.now + (3600* 13) # server offset(+13 hours:Japan)
	end

	def elapsed
		return ((@time.hour) * 60 * 60) + (@time.min * 60) + @time.sec
	end

	def timeInt
		return ((elapsed / 86400.0) * 1000000).to_i
	end

	def format_normal
		timeIntString = timeInt.to_s.rjust(4, '0')
		return timeIntString[0,3]+":"+timeIntString[3,3]
	end

	def default
		return format_normal
	end

end