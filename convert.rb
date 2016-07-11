#!/usr/bin/env  ruby

$indexFile = File.open("index.html","a+")

class StringUtil
	
end



su=new StringUtil()
File.open(ARGV[0],"r") do |file|
	while line = file.gets
		if line.include?("###") and line.index('#') == 1



	

