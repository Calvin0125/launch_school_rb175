require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"
require 'yaml'

def calculate_interests(users)
  count = 0
  users.each do |user, details|
    count += details[:interests].length
  end
  count
end

before do 
  @users = YAML.load_file("users.yaml")
end

get "/" do
  @usernames = @users.keys.map(&:to_s)
  erb :users
end

get "/details" do
  @user = params[:user].to_sym
  erb :details
end