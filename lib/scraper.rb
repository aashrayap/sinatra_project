require 'mechanize'
require 'pry'
require 'csv'
require_relative 'locator'

Job=Struct.new(:title,:company,:link,:location)

class Scraper

  def initialize(keyword,city=nil)
    @jobarray=[]

    scraper= Mechanize.new
    scraper.history_added = Proc.new { sleep 0.5 }

    page=scraper.get("http://www.dice.com/")
    result=page.form_with(:id=>'search-form')
    result.q=keyword

    if city==nil
    locator=Locator.new
    city=locator.location["city"]
    end

    result.l=city
    result_page = scraper.submit(result)

    result_page.links_with(:href => /detail/).each do |link|

     if @jobarray.size >1
        break
      else
      current_job=Job.new
      current_job.title=link.text.strip

      description_result_page=link.click
      holder =description_result_page.link_with(:href => /company/) 
      current_job.company=holder.text
      current_job.link=link
      current_job.location = description_result_page.search("li.location").text
      @jobarray<<current_job
      end
    end
  end

  def return_job_array
    @jobarray
  end
end

scraper=Scraper.new('engineer','toronto')
puts scraper.return_job_array
