require 'sinatra'
require 'rest-client'
require 'pry'
require 'json'
require 'date'

get '/' do
  response = RestClient.get('https://todoist.com/api/v8/sync', {
    params: {
      token: File.open('token', 'r').readlines.first,
      resource_types: '["items"]'
    }
  })

  items = JSON.parse(response.body)['items']


  today = items.select do |item|
    item['due'] && item['due']['date'] == Date.today.to_s
  end

  body = if today.empty?
    "Nothing to do!"
  else
    today.sample['content']
  end

  <<~BODY
<style>
  div { 
    font-family: sans-serif;
    text-align: center;
    width: 100%;
    font-size: 4em;
    padding-top: 100px;
  }
</style>
<div>Do this next: #{body}</div>
  BODY
end
