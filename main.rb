#!/bin/env ruby
# encoding: utf-8

$timeStart = Time.new

# Imports

require 'date'

# Generals

require_relative "inc/objects/string.rb"
require_relative "inc/objects/desamber.rb"
require_relative "inc/objects/horaire.rb"
require_relative "inc/objects/log.rb"
require_relative "inc/objects/lexicon.rb"
require_relative "inc/objects/link.rb"
require_relative "inc/objects/laeth.rb"
require_relative "inc/objects/issue.rb"
require_relative "inc/objects/term.rb"
require_relative "inc/objects/dictionaery.rb"
require_relative "inc/objects/clock.rb"
require_relative "inc/objects/icon.rb"
require_relative "inc/objects/image.rb"
require_relative "inc/objects/page.rb"
require_relative "inc/objects/layout.rb"
require_relative "inc/objects/aeth.rb"
require_relative "inc/objects/graph.rb"

class Site

	def initialize query

		@query = query

		@data = {
		  "topic"   => @query,
		  "module"  => "",
		  "lexicon" => $jiin.command("disk load lexicon"),
		  "horaire" => $jiin.command("disk load horaire"),
		  "issues" => []
		}

		@page   = Page.new(@data)
		@layout = Layout.new(@page)

	end

	def view

		return "
		<!DOCTYPE html>
		<html> 
		<head>
			<meta charset='UTF-8'>
			<meta name='viewport'            content='width=device-width, initial-scale=1, maximum-scale=1'>
			<meta name='color:Accent'        content='#7cc0b0'>
			<meta property='og:title'        content='XXIIVV ∴ NEON HERMETISM'/>
			<meta property='og:type'         content='website'/>
			<meta property='og:url'          content='http://wiki.xxiivv.com/"+@query+"'/>
			<meta property='og:image'        content='http://wiki.xxiivv.com/content/diary/001.jpg'/>
			<meta property='og:email'        content='me@m0oo.com'/>
			<meta property='og:site_name'    content='Neon Hermetism'/>
			<meta property='fb:admins'       content='deoxys'/>
			<meta name='SKYPE_TOOLBAR' 		 content='SKYPE_TOOLBAR_PARSER_COMPATIBLE' />
			<meta name='apple-mobile-web-app-capable' content='yes' />
			<meta name='viewport' 			 content='width=device-width, initial-scale=1.0'>
			<meta name='description'         content='Works of Devine Lu Linvega' />
			<meta name='keywords'            content='aliceffekt, traumae, ikaruga, devine lu linvega' />
		  	<meta name='apple-mobile-web-app-capable' content='yes'>

			<script src='https://ajax.googleapis.com/ajax/libs/jquery/1.8.1/jquery.min.js' ></script>

			<link rel='shortcut icon' 		 href='http://wiki.xxiivv.com/img/interface/favicon.ico' />
			<link rel='apple-touch-icon-precomposed' 	 href='../../img/interface/phone_xxiivv.png'/>
			<link href='http://fonts.googleapis.com/css?family=Abel' rel='stylesheet' type='text/css'>
			<link rel='shortcut icon' href='http://wiki.xxiivv.com/img/interface/favicon.ico' />
		  	<link rel='apple-touch-icon' href='http://wiki.xxiivv.com/img/interface/icon_ios_xxiivv.png'>

			<link rel='stylesheet'           type='text/css'                 href='inc/style.reset.css?v=2' />
			<link rel='stylesheet'           type='text/css'                 href='inc/style.main.css?v=2' />
			<script 														 src='inc/jquery.main.js?v=2'></script>

			<title>"+@layout.title+"</title>
		</head>
		<body>"+@layout.view+"</body>
		</html>
		"

	end

end
