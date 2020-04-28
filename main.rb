require 'open-uri'
require_relative './utils/downloadIfNeeded'
require_relative './WikiIndexScraper'
require_relative './TeamData'

require_relative './utils/identifyOddChars'

indexFileUrl = "https://en.wikipedia.org/wiki/Category:Formula_One_entrants"
htmlDirectory = Dir.getwd + "/HTML/"
indexFileName = "TeamIndex.html"

html = downloadIfNeeded(filename: indexFileName, url: indexFileUrl, targetDirectory: htmlDirectory)

teamsWithHtml = WikiIndexScraper.new(html: html, htmlDirectory: htmlDirectory).scrape
# teamsWithHtml = Array<{:name=>"Zakspeed", :wikiLink=>"/wiki/Zakspeed", html: ...}>


teamsData = teamsWithHtml.map{ |team|
  TeamData.new(team).extract
}

puts teamsData