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

  def find_primary_key_override(primary_key)
    overrides = {
      'benetton-formula1986-2001lotus-f1-team2012-2015': 'lotus-f1',
      'brawn-gp-formula-one-team': 'brawn-gp',
      'caterham-f1-team': 'caterham-f1',
      'honda-in-formula-one': 'honda-racing-f1-team',
      'jaguar-racing-f1-team': 'jaguar-racing',
      'lotus-racing/team-lotus': 'lotus-racing',
      'lotus-renault-gp': 'renault-in-formula-one',
      'manor-marussia-f1-team': 'marussia-f1',
      'marussia-f1-team': 'marussia-f1',
      'marussia-virgin-racing': 'virgin-racing',
      'mercedes-gp-petronas-formula-one-team': 'mercedes-benz-in-formula-one',
      'minardi': 'minardi-f1-team',
      'osella': 'osella-squadra-corse',
      'sahara-force-india': 'force-india',
      'sauber-f1-team': 'sauber-motorsport',
      'spyker-f1': 'spyker-f1-team',
      'team-lotus-2010-11': 'lotus-racing',
      'toleman': 'toleman-motorsport',
      'force-india-f1-team': 'force-india',
      'alfa-romeo-racing': 'alfa-romeo-in-formula-one',
      'renault-sport-f1-team': 'renault-in-formula-one',
      'renault-f1-team': 'renault-in-formula-one',
    }

    overrides[primary_key.to_sym] || primary_key
  end

  def make_primary_key(str)
    if str
      primary_key = str.downcase.gsub(' ', '-').gsub('–', '-').gsub(/[\(\)'\.]/, '').gsub('é', 'e')
      
      find_primary_key_override(primary_key)
    else
      nil
    end
  end

  def extract
    data = {
      primaryKey: make_primary_key(@team[:nameInIndex]),
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
      nextName: make_primary_key(get_info('Next name')),
      previousName: make_primary_key(get_info('Previous name')),
      notedDrivers: get_info('Noted drivers'),
      notedStaff: get_info('Noted staff'),
      teamPrincipal: get_info('Team principal'),
      technicalDirector: get_info('Technical Director'),
      results2019: get_info('2019 position'),
      notes: nil,
    }

    @team.merge(data).tap{|t| t.delete(:html) }
  end
end
