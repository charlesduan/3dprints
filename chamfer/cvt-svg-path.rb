#!/usr/bin/ruby

require 'nokogiri'

class SVGParser

  def initialize()
    @paths = []
  end

  def cmd_M(arr)
    @paths.push([ arr.shift(2).map(&:to_f) ])
  end

  def cmd_L(arr)
    @paths.push([]) if @paths.empty?
    @paths.last.push(arr.shift(2).map(&:to_f))
  end

  def cmd_z(arr)
  end

  def report
    return @paths.inspect
  end
end

open(ARGV[0]) do |io|
  p = SVGParser.new()
  doc = Nokogiri::XML(io)
  arr = doc.at_xpath('//xmlns:path/@d').content.strip.split(/[\s,]+/)
  until arr.empty?
    cmd = ("cmd_" + arr.shift).to_sym
    if p.respond_to?(cmd)
      p.send(cmd, arr)
    else
      warn("Unknown command #{cmd}")
    end
  end

  puts p.report

end
