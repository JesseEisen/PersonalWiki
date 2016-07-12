#!/usr/bin/env  ruby

$indexFile = File.open("index.html","a+")
$file = File.open(ARGV[0],"r") 
$h4Front='<h4><a href="#" class="btn" onclick="showandhide(this);return false;">'
$hideDiv='<div class="hidecontent">'

class StringUtil
	@@InCodeBlock = 0
	@@InParaBlock = 1  #if not code and list, that should be paragraph
	@@InListBlock = 0
	@@NeedInsetEnd = 0
	@@FirstCodeFlag = 0
	def StringUtil.InsertDiv()
		if @@NeedInsetEnd == 0
			@@NeedInsetEnd = 1
		else
			$indexFile.puts "</div>"
		end
	end

	def InsertTitle(line)
		last=line.length
		$indexFile.print "<h1>",line[1,last].chomp,"</h1>"
		$indexFile.puts
		$indexFile.puts '</div>','<div class="content">'
	end

	def InsertH3(line)
		last=line.length-1
		$indexFile.print "<h3>",line[3,last].chomp,"</h3>"
		$indexFile.puts
	end

	def InsertShowDiv()
		$indexFile.puts '<p class="showdetial"><a class="clicks" href="#" onclick="showdiv(this);return false;">show more detials</a></p>','<div class="moredetial">'
	end

	def InsertHideBtn()
		StringUtil.InsertDiv()
		$indexFile.puts '<div class="btm">',' <a href="#" class="btn" onclick="hidediv(this);">Hide Detials</a>','</div>','</div>'
	end

	def InsertAssociate()
		StringUtil.InsertDiv()
		$indexFile.print $h4Front,'Associated Contents',"</a></h4>"
		$indexFile.puts
		$indexFile.puts $hideDiv
	end

	def InsertRef()
		StringUtil.InsertDiv()
		$indexFile.print $h4Front,'Some References',"</a></h4>"
		$indexFile.puts
		$indexFile.puts $hideDiv
	end

	def InsertIdiom()
		StringUtil.InsertDiv()
		$indexFile.print $h4Front,'Some Idioms',"</a></h4>"
		$indexFile.puts
		$indexFile.puts $hideDiv
	end

	def InsertList(line)
		len = line.length - 1
		if @@InListBlock == 0
			@@InListBlock = 1
			$indexFile.puts "<ul>"
		end
		$indexFile.print "<li>", line[1,len].chomp, "</li>"
		$indexFile.puts
	end

	def InsertCode()
		@@InParaBlock = 0
		if @@FirstCodeFlag == 0
			@@FirstCodeFlag = 1
			$indexFile.puts '<div class="codes">'
			$indexFile.puts '<pre> <code>'
		else
			$indexFile.puts '</code> </pre> </div>'
			@@FirstCodeFlag = 0
		end
	end

	def InsertDirectly(line)
		len = line.length-1
		if @@InParaBlock == 1
	    	$indexFile.print "<p>",line[1,len].chomp, "</p>"
			$indexFile.puts
		else @@InCodeBlock == 1
			$indexFile.puts line[1,len+1]
		end
	end

	def ResetParameter()
		if @@InListBlock == 1
			$indexFile.puts "</ul>"
		end
		@@InCodeBlock = 0
		@@InListBlock = 0
		@@InParaBlock = 1
	end

	def ResetAll()
		@@InParaBlock = 1
		@@InCodeBlock = 0
		@@InListBlock = 0
		@@NeedInsetEnd = 0
		@@FirstCodeFlag = 0
	end
end



def ParserFile(su)
	while line = $file.gets
		if line.include?("###") and line.index('#') == 0
			su.InsertH3(line)
		elsif line.include?("Show") and line.strip.length == 4
			su.InsertShowDiv() #here we will flag a global var 
		elsif line.include?("Hide") and line.strip.length == 4
			su.InsertHideBtn()
		elsif line.include?("Associated") and line.strip.length == 10
			su.InsertAssociate()
		elsif line.include?("Reference") and line.strip.length == 9
			su.InsertRef()
		elsif line.include?("Idioms") and line.strip.length == 6
			su.InsertIdiom()
		elsif line.include?("----") and line.index('-') == 0
			su.InsertCode()
		elsif line.include?("+") and line.index('+') == 0
			su.InsertList(line)
		elsif line.length == 1
			su.ResetParameter()
			next
		elsif line.include?("#") and line.index('#') == 0
			su.InsertTitle(line)
		elsif line.include?(">") and line.index('>') == 0
			su.InsertDirectly(line)
		elsif line.include?("====") and line.index('=') == 0
			su.ResetAll()
		end
	end
end

sut=StringUtil.new()
ParserFile(sut)
$indexFile.puts "</div>", "</body>", "</html>"
$indexFile.close


	

