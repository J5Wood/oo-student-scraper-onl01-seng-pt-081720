require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    scrape_hash = []
    doc = Nokogiri::HTML(open(index_url))
    doc.css(".student-card").each do |post|
      title = post.css("h4").text
      scrape_hash << {
        :name => post.css("h4").text,
        :location => post.css(".student-location").text,
        :profile_url => post.css("a").attribute("href").value
      }
    end
    scrape_hash
  end

  def self.scrape_profile_page(profile_url)
    link_hash = {}
    link_array =[]
    doc = Nokogiri::HTML(open(profile_url))
    doc.css(".social-icon-container //a").each do |x|
      link_array << x.attribute("href").value
    end
    link_array.each do |url|
      if url.match(/twitter.com/)
        link_hash[:twitter] = url
      elsif url.match(/linkedin.com/)
        link_hash[:linkedin] = url
      elsif url.match(/github.com/)
        link_hash[:github] = url
      elsif url.match(/.com/)
        link_hash[:blog] = url
      end
    end
    link_hash[:profile_quote] = doc.css(".profile-quote").text
    link_hash[:bio] = doc.css(".description-holder p").text
    link_hash
  end

end
