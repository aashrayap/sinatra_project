require 'sinatra'
require 'erb'
require './lib/scraper.rb'

get '/' do 
  erb :index
end

post '/result_page' do
  keyword = params[:jobsearch]
  scraper = Scraper.new(keyword,location)
  results = scraper.return_job_array
  erb :result_page, :locals => {:results => results}
end 