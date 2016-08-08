#!/bin/env ruby
# encoding: utf-8

require 'date'

$timeStart = Time.new

Dir["#{$jiin_path}/disk/http.oscean/inc/objects/*"].each do |file_name|
	load(file_name)
end

class Oscean

	include Lamp

	def initialize query

	end

	def application query = "Home"

		@query = query != "" ? query.gsub("+"," ").split(":").first : "Home"
		@module = query.include?(":") ? query.gsub("+"," ").split(":").last : ""

		@data = {
		  "topic"   => @query,
		  "module"  => @module,
		  "lexicon" => $jiin.command("grid lexicon").to_h,
		  "horaire" => $jiin.command("flat horaire").to_a
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