require 'mechanize'
require 'pry'
require 'csv'

Job=Struct.new(:title,:company,:link)

class Scraper

  def initialize(keyword)
    @jobarray=[]

    scraper= Mechanize.new
    scraper.history_added = Proc.new { sleep 0.5 }

    page=scraper.get("http://www.dice.com/")
    result=page.form_with(:id=>'search-form')
    result.q=keyword

    page = scraper.submit(result)

    page.links_with(:href => /detail/).each do |link|

     if @jobarray.size >3
        break
      else
      current_job=Job.new
      current_job.title=link.text.strip

      description_page=link.click
      holder =description_page.link_with(:href => /company/) 
      current_job.company=holder.text
      current_job.link=link
      @jobarray<<current_job
      end
    end
  end

  def return_job_array
    @jobarray
  end
end