#!/bin/env ruby
# encoding: utf-8

$nataniev.require("corpse","http")

class VesselOscean

  include Vessel

  def initialize id = 0

    super

    @name = "Oscean"
    @path = File.expand_path(File.join(File.dirname(__FILE__), "/"))

    load_folder("#{@path}/actions/*")

    install(:default,:serve)
    install(:default,:debug)
    install(:default,:complete)
    install(:default,:help)

  end

end