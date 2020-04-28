require 'nokogiri'
require 'pry'

class TeamData
  def initialize(team)
    # team = Array<{:name=>"Zakspeed", :wikiLink=>"/wiki/Zakspeed", html: ...}>
    doc = Nokogiri::HTML(team[:html])
    @summary = doc.css('table.infobox.vcard')
    @team = team
  end

  def find_row(heading)
    @summary.css('tr').find{|row|
      row.css('th').text.gsub("\n", ' ').downcase.match(heading.downcase)
    }
  end

  def get_info(heading)
    row = find_row(heading)
  
    if row
      row.css('td').text
    else
      nil
    end
  end

  def make_primary_key
    @team[:nameInIndex].downcase.gsub(' ', '-').gsub('–', '-').gsub(/[\(\)'\.]/, '').gsub('é', 'e')
  end

  def extract
    data = {
      primaryKey: make_primary_key,
      name: get_info('Full name') || @team[:nameInIndex],
      base: get_info('Base'),
      website: get_info('Website'),
      constructorChampionships: get_info("Constructors'Championships"),
      driverChampionships: get_info("Drivers'Championships"),
      fastestLaps: get_info('Fastest laps'),
      polePositions: get_info('Pole positions'),
      points: get_info('Points'),
      podiums: get_info('Podiums'),
      victories: get_info('Race victories'),
      racesEntered: get_info('Races entered'),
      finalEntry: get_info('Final entry'),
      firstEntry: get_info('First entry'),
      engines: get_info('Engines'),
      founders: get_info('Founder'),
      nextName: get_info('Next name'),
      previousName: get_info('Previous name'),
      notedDrivers: get_info('Noted drivers'),
      notedStaff: get_info('Noted staff'),
      teamPrincipal: get_info('Team principal'),
      technicalDirector: get_info('Technical Director'),
      results2019: get_info('2019 position'),
    }

    @team.merge(data).tap{|t| t.delete(:html) }
  end
end
