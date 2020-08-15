require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

URL = 'https://www.indeed.co.uk/jobs?q=software+developer&start='

def getTotal
  curUrl = URL + "10"
  unparsed_page = HTTParty.get(curUrl)
  
  if unparsed_page.body.nil? || unparsed_page.body.empty?
    puts 'GET did not return a page'
    exit
  end

  parsed_page = Nokogiri.HTML(unparsed_page)
  
  job_listings = parsed_page.css('div.jobsearch-SerpJobCard')
  puts per_page = job_listings.count
  
  puts total =
         parsed_page.css(
           'div#searchCountPages'
         ).text.strip.split[
           3
         ].delete(',')
         
  return (total.to_i/per_page) + 1
end

def scraper(page)
  curUrl = URL + page.to_s
  unparsed_page = HTTParty.get(curUrl)
  
  if unparsed_page.body.nil? || unparsed_page.body.empty?
    puts 'GET did not return a page'
    exit
  end

  parsed_page = Nokogiri.HTML(unparsed_page)
  jobs = Array.new
  job_listings = parsed_page.css('div.jobsearch-SerpJobCard')
  
  job_listings.each do |job_listing|
    job = {
      title: job_listing.css('a.jobtitle').text.gsub("\n",""),
      company: job_listing.css('span.company').text.gsub("\n",""),
      location: job_listing.css('div.location').text.gsub("\n",""),
      # url:
      #   'https://www.indeed.co.uk' +
      #     job_listing.css('a')[0].attributes['href'].value
    }
    jobs << job
  end
  puts jobs.to_s
end

# (1..getTotal).each { |num|
#    scraper(num*10)
# } 

puts getTotal