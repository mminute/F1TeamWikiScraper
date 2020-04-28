require 'nokogiri'
require_relative './Constants'
require_relative './utils/downloadIfNeeded'

class WikiIndexScraper
  def initialize(html:, htmlDirectory:)
    @doc = Nokogiri::HTML(html)
    @htmlDirectory = htmlDirectory
  end

  def get_teams_html(teams)
    puts "Getting html for teams..."
    
    teamsDir = @htmlDirectory + 'Teams/'

    teamsWithHtml = teams.map { |team|
      # {:name=>"Zakspeed", :wikiLink=>"/wiki/Zakspeed"}
      destination = team[:wikiLink].match(/\/wiki\/(.*)/).captures.first + '.html'

      html = downloadIfNeeded(filename: destination, url: Constants[:wikipedia] + team[:wikiLink], targetDirectory: teamsDir)
      
      team.merge({ html: html })
    }
  end

  def scrape_index
    @doc.css('div#mw-pages li a').map { |team|
      { nameInIndex: team.text, wikiLink: team.attributes['href'].value }
    }
  end

  def scrape
    teams = scrape_index()
    get_teams_html(teams)
  end
end