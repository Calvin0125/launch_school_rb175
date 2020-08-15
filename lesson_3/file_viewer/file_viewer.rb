require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

get "/" do
  @files = Dir.glob("public/*").sort.map { |file| file.split('/')[1] }
  @files.reverse! if params[:sort] == "desc"
  erb :home
end
