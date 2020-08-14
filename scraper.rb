require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

def scraper
  url = 'https://www.indeed.co.uk/software-developer-jobs-in-Birmingham'
  unparsed_page = HTTParty.get(url)
  if unparsed_page.body.nil? || unparsed_page.body.empty?
    puts 'GET did not return a page'
    exit
  end

  parsed_page = Nokogiri.HTML(unparsed_page)
  jobs = Array.new
  job_listings = parsed_page.css('div.jobsearch-SerpJobCard')
  per_page = job_listings.count
  puts total =
         parsed_page.css(
           'div.resultsTop > div.secondRow > div > div > div#searchCountPages'
         ).text.strip.split[
           3
         ]
  job_listings.each do |job_listing|
    job = {
      title: job_listing.css('a.jobtitle').text,
      company: job_listing.css('span.comapany'),
      location: job_listing.css('div.location').text,
      url:
        'https://www.indeed.co.uk' +
          job_listing.css('a')[0].attributes['href'].value
    }
    jobs << job
  end
  byebug
end

scraper
