#!/usr/bin/env ruby
require 'rubygems'
require 'fileutils'
require 'sinatra'
require 'dm-core'
require 'dm-timestamps'
require 'dm-validations'
require 'dm-aggregates'
require 'haml'
require 'sass'

DIR = Dir.pwd

# Database stuff. {{{1
class Page
    include DataMapper::Resource

    property :id, Serial
    property :name, Text, :nullable => false
    property :content, Text, :nullable => false
end

DataMapper::setup(:default, "sqlite3://#{DIR}/qwicky.db")
DataMapper::auto_upgrade!

# Settings stuff. {{{1
FileUtils.touch("#{DIR}/qwicky.yml") unless File.exist?("#{DIR}/qwicky.yml")

CONF = {
    :homepage => 'Home',
    :template_engine => 'text',
}.merge(
    open("#{DIR}/qwicky.yml") { |f|
        YAML::load(f) || Hash.new
    }
)

MARKUP =
    begin
        case CONF[:template_engine]
        when 'markdown'
            require 'bluecloth'
            lambda { |text|
                BlueCloth.new(text).to_html
            }
        when 'rdoc'
            require 'rdoc/markup/simple_markup'
            lambda { |text|
                SM::SimpleMarkup.new.convert(text, SM::ToHtml.new)
            }
        when 'textile'
            require 'redcloth'
            lambda { |text|
                RedCloth.new(text).to_html
            }
        when 'text'
            lambda { |text| text }
        else
            raise RuntimeError.new("Unknown template engine: #{CONF[:template]}")
        end
    rescue LoadError => boom
        puts "Could not load template engine #{CONF[:template_engine]}."
        puts "Seems like you didn't install the appropriate gem?"
        puts "Switching to simple text mode."
        lambda { |text| text }
    end

# Routes. {{{1
helpers do
    def redirect_home
        redirect "/#{CONF[:homepage]}"
    end

    def markup text
        MARKUP.call(text)
    end
end

get '/' do
    redirect_home
end

get '/.settings' do
    @settings = CONF
    @title = 'Settings'
    haml :settings
end

post '/.settings' do
    CONF.merge!(params[:settings])
    open("#{DIR}/qwicky.yml", 'w') { |f|
        f.write(YAML::dump(CONF))
    }
    
    redirect_home
end

get '/:page' do |page|
    @page = Page.first(:name => page)
    redirect "/#{page}/edit" if @page.nil?
    @title = page
    haml :page
end

get '/:page/edit' do |page|
    @page = Page.first(:name => page) || Page.new(:name => page)
    @title = "Editing #{page}"
    haml :edit
end

post '/:page' do |page|
    @page = Page.first(:name => page) || Page.new
    @page.name = params[:name]
    @page.content = params[:content]
    @page.save

    redirect "/#{page}"
end

delete '/:page' do |page|
    page = Page.first(:name => page)
    page.destroy unless page.nil?

    redirect_home
end

