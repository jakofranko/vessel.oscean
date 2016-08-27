#!/bin/env ruby
# encoding: utf-8

$vessel_path = File.expand_path(File.join(File.dirname(__FILE__), "/"))

require 'date'

$timeStart = Time.new

Dir["#{$vessel_path}/inc/objects/*"].each do |file_name|
	load(file_name)
end

class Oscean

	def http q = "Home"

		@query = q != "" ? q.gsub("+"," ").split(":").first : "Home"
		@module = q.include?(":") ? q.gsub("+"," ").split(":").last : ""

		@data = {
		  "topic"   => @query,
		  "module"  => @module,
		  "lexicon" => En.new("lexicon").to_h,
		  "horaire" => Di.new("horaire").to_a
		}

		@page   = Page.new(@data)
		@layout = Layout.new(@page)

		$photo = @page.diary ? @page.diary.photo : nil

		return "
		<!DOCTYPE html>
		<html> 
		<head>
			<meta charset='UTF-8'>
			<meta name='viewport'            content='width=device-width, initial-scale=1, maximum-scale=1'>
			<meta name='apple-mobile-web-app-capable' content='yes' />
			<meta name='viewport' 			 content='width=device-width, initial-scale=1.0'>
			<meta name='description'         content='Works of Devine Lu Linvega' />
			<meta name='keywords'            content='aliceffekt, traumae, ikaruga, devine lu linvega' />
		  	<meta name='apple-mobile-web-app-capable' content='yes'>

			<script src='https://ajax.googleapis.com/ajax/libs/jquery/1.8.1/jquery.min.js' ></script>

			<link rel='shortcut icon' 		 href='http://wiki.xxiivv.com/img/interface/favicon.ico' />
			<link rel='apple-touch-icon-precomposed' 	 href='../../img/interface/phone_xxiivv.png'/>
			<link rel='shortcut icon' href='http://wiki.xxiivv.com/img/interface/favicon.ico' />

			<link rel='stylesheet'           type='text/css'                 href='inc/style.reset.css' />
			<link rel='stylesheet'           type='text/css'                 href='inc/style.main.css' />
			<script 														 src='inc/jquery.main.js'></script>

			<title>"+@layout.title+"</title>
		</head>
		<body>"+@layout.view+"</body>
		</html>
		"
	end

end