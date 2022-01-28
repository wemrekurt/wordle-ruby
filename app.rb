require 'sinatra'
require "sinatra/namespace"
require_relative 'trie'

$trie = Trie.new
IO.readlines('words', chomp: true).each { |word| $trie.insert(word) }

namespace '/api/v1' do
  before do
    content_type 'application/json'
  end

  helpers do
    def base_url
      @base_url ||= "#{request.env['rack.url_scheme']}://{request.env['HTTP_HOST']}"
    end

    def json_params
      begin
        JSON.parse(request.body.read)
      rescue
        halt 400, { message:'Invalid JSON' }.to_json
      end
    end

    def halt_if_not_found!
      halt(404, { message:'Not Found'}.to_json) unless book
    end
  end

  def wordle_map(word, wordle)
    found = $trie.search(word)
    li = []
    if found
      word.each_char.with_index do |char, j|
        li << (wordle.include?(char) ? (wordle[j] == char ? 'g' : 'y') : 'r')
      end
    end
    { word: word, found: found, map: li }
  end

  get '/check/:word' do |word|
    wordle = 'erika'
    wordle_map(word, wordle).to_json
  end

  get '/check/:word/:wordle' do |word, wordle|
    wordle_map(word, wordle).to_json
  end
end


