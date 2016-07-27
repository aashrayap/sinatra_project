require 'sinatra'
require 'erb'
require './lib/scraper.rb'
require './lib/locator.rb'


get '/' do 
  erb :index
end

enable :sessions

post '/result_page' do
  locatorr = Locator.new
  city=locatorr.location['city']
  session['location']=city
  keyword = params[:jobsearch]
  location=params[:location]
  puts location.inspect
  puts location.inspect
  if location==''
    scraper = Scraper.new(keyword,city)
  else
    scraper = Scraper.new(keyword,location)
  end
  results = scraper.return_job_array
  erb :result_page, :locals => {:results => results}
end