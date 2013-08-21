require 'rubygems'
require 'httparty'
require 'nokogiri'
require 'json'

BASE_URL = 'http://cosmicencounter.wikia.com/'

COMPLEXITY = {
    'background:#00ff00' => :green,
    'background:#ffff00' => :yellow,
    'background:#ff0000' => :red,
}

def query(url)
  Nokogiri(HTTParty.get(url).body)
end

VERSIONS  = [
    {:path => 'wiki/FFG', :file => '0-cosmic_encounter.json'},
    {:path => 'wiki/Cosmic_Incursion', :file => '1-cosmic_incursion.json'}
]


def get_all_aliens_in_page(page_path)
  page = query(File.join(BASE_URL, page_path))
  page.search('#mw-content-text div:first a[title]').map do |el|
    get_alien_details el.attr('href')
  end
end

def get_alien_details(alien_page_path)
  #puts "Query alien #{alien_page_path}"
  page = query(File.join(BASE_URL, alien_page_path))

  alien_name = page.search('#WikiaPageHeader h1').text.strip

  sidebar = page.search('table.infobox').last

  color_raw = sidebar.search('tr:first th').attr('style').value.gsub(';','')
  complexity = COMPLEXITY[color_raw.strip]
  image_el = sidebar.search('img').first
  image_url = image_el.attr('data-src')
  image_url = image_el.attr('src') if image_url.nil?

  description = sidebar.search('tr')[2].text.strip

  info = {
      :name => alien_name,
      :description => description,
      :complexity => complexity,
      :image_url => image_url,
  }

  #puts "Found this info #{info.inspect}"
  info
end

VERSIONS.each do |version|
  all_aliens = get_all_aliens_in_page(version[:path])
  File.write(version[:file], all_aliens.to_json)
end
