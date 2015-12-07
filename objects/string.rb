#!/bin/env ruby
# encoding: utf-8

class String

	def template

		replacement = self
		self.scan(/(?:\{\{)([\w\W]*?)(?=\}\})/).each do |text, something|
			replacement = replacement.gsub("{{#{text}}}",parser(text))
		end
		return replacement

	end

	def parser text

		if $lexicon.find(text) then text = local_link(text) end
		if text.include?("|") then text = deferred_link(text) end

		if text == "TIME" then text = Clock.new().default end
		if text == "DATE" then text = Desamber.new().default end
		if text.length == 10 && text[4,1] == "-" then text = Desamber.new(text).default end 

		return text

	end

	def deferred_link text

		values = text.split("|") ; title = values.first ; url = values[1]
		style = (url && url.include?("http")) ? "external" : "local"
		return "<a class='#{style}' href='#{url}'>#{title}</a>"

	end

	def local_link text

		return ($page.topic == text) ? "<b>#{text}</b>" : "<a href='/#{text}' class='local'>#{text}</a>"

	end

	def firstParagraph

		if !self.include?("</p>") then return self end
		return "<p>"+self.split('</p>')[0].gsub('<p>','')+"</p>"

	end

end