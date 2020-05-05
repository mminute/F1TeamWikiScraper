require 'open-uri'
require_relative './utils/downloadIfNeeded'
require_relative './WikiIndexScraper'
require_relative './TeamData'
require_relative './manualTeamData'
require_relative './utils/writeJSObject'

indexFileUrl = "https://en.wikipedia.org/wiki/Category:Formula_One_entrants"
htmlDirectory = Dir.getwd + "/HTML/"
indexFileName = "TeamIndex.html"

html = downloadIfNeeded(filename: indexFileName, url: indexFileUrl, targetDirectory: htmlDirectory)

teamsWithHtml = WikiIndexScraper.new(html: html, htmlDirectory: htmlDirectory).scrape

teamsData = teamsWithHtml.map{ |team|
  TeamData.new(team).extract
} + ManualTeamData

write_to_file = '['

teamsData.each { |team|
    write_to_file = write_to_file + "\n" + "  #{write_js_object(team)}"
}

write_to_file = write_to_file + "\n]"

IO.write(Dir.getwd + '/Output/teams.js', write_to_file)