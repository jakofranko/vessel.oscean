#!/bin/env ruby
# encoding: utf-8

class VesselOscean

  include Vessel

  def initialize id = 0

    super

    @name = "Oscean"
    @path = File.expand_path(File.join(File.dirname(__FILE__), "/"))
    @docs = "The Oscean wiki engine toolchain."
    @site = "http://wiki.xxiivv.com"

    install(:custom,:serve)
    install(:custom,:debug)
    install(:generic,:document)
    install(:generic,:help)

  end

end