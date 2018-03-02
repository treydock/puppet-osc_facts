#!/usr/bin/env ruby

require 'yaml'

if ARGV.size != 2
    puts "yaml-marshal.rb [input] [output]"
    exit(1)
end

INPUT = ARGV[0]
OUTPUT = ARGV[1]

yamlinput = YAML.load(File.read(INPUT))

File.open(OUTPUT, 'w+') { |f| f.write(Marshal.dump(yamlinput)) }
