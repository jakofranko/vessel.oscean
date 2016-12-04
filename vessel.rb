#!/bin/env ruby
# encoding: utf-8

$nataniev.require("corpse","http")

class VesselOscean

  include Vessel

  def initialize id = 0

    super

    @name = "Oscean"
    @path = File.expand_path(File.join(File.dirname(__FILE__), "/"))
    @docs = "The Oscean wiki engine toolchain."

    load_folder("#{@path}/actions/*")

    install(:custom,:serve)
    install(:custom,:debug)
    install(:generic,:help)
    install(:generic,:document)

  end

end