require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

helpers do
  def in_paragraphs(text)
    text.map.with_index do |paragraph, index|
      "<p id='p#{index}'>#{paragraph}</p>"
    end.join
  end

  def highlight(text, term)
    text.gsub(term, %(<strong>#{term}</strong>))
  end
end

before do
  @contents = File.readlines("data/toc.txt")
end

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  erb :home
end

get "/chapters/:number" do
  number = params[:number].to_i
  chapter_title = @contents[number - 1]
  redirect "/" unless chapter_title
  @title = "Chapter #{number}: #{chapter_title}"
  @chapter = File.readlines("data/chp#{number}.txt", "\n\n")
  erb :chapter
end

def each_chapter
  @contents.each_with_index do |name, index|
    number = index + 1
    contents = File.read("data/chp#{number}.txt")
    yield(number, name, contents)
  end
end

def matching_chapters(query)
  results = []

  return results if !query || query.empty?

  each_chapter do |number, name, contents|
    matches = {}
    contents.split("\n\n").each_with_index do |paragraph, index|
      matches[index] = paragraph if paragraph.include?(query)
    end
    results << {number: number, name: name, paragraphs: matches} if matches.any?
  end

  results
end

get "/search" do
  @results = matching_chapters(params[:query])
  erb :search
end

not_found do
  redirect "/"
end

