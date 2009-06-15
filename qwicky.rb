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

# Markup stuff. {{{1
module Markup
    class Markup
        class << self
            def [] type
                @@markups ||= Hash.new
                @@markups[type]
            end

            def type id
                @@markups ||= Hash.new
                @@markups[id] = self
            end
        end

        def format text
            text
        end
    end

    class MText < Markup
        type 'text'
    end

    class MMarkdown < Markup
        type 'markdown'

        def initialize
            unless Object.const_defined?(:Markdown)
                begin
                    require 'rdiscount'
                    return
                rescue LoadError => boom
                end

                begin
                    require 'peg_markdown'
                    return
                rescue LoadError => boom
                end

                begin
                    require 'maruku'
                    Object.const_set(:Markdown, Maruku)
                    return
                rescue LoadError => boom
                end

                begin
                    require 'bluecloth'
                    return
                rescue LoadError => boom
                    puts "Looks like you don't have a Markdown interpreter installed!"
                    puts "Please get one, like"
                    puts "* RDiscount"
                    puts "* peg-markdown"
                    puts "* Maruku"
                    puts "* BlueCloth"
                    puts "Reverting to simple text markup"
                    throw :revert
                end
            end
        end

        def format text
            Markdown.new(text).to_html
        end
    end

    class MTextile < Markup
        type 'textile'

        def initialize
            unless Object.const_defined?(:RedCloth)
                begin
                    require 'redcloth'
                rescue LoadError => boom
                    puts "Looks like you don't have RedCloth installed!"
                    puts "This is the gem needed to render Textile syntax"
                    puts "Reverting to simple text markup"
                    throw :revert
                end
            end
        end

        def format text
            RedCloth.new(text).to_html
        end
    end

    class MRDoc < Markup
        type 'rdoc'
        
        def initialize
            unless Object.const_defined?(:SM)
                begin
                    require 'rdoc/markup/simple_markup'
                    require 'rdoc/markup/simple_markup/to_html'
                rescue LoadError => boom
                    puts "Looks like you don't have RDoc installed!"
                    puts "This is the gem needed to render RDoc syntax"
                    puts "Reverting to simple text markup"
                    throw :revert
                end
            end
        end

        def format text
            SM::SimpleMarkup.new.convert(text, SM::ToHtml.new)
        end
    end
end

# App class. {{{1
class Qwicky
    attr_accessor :conf, :markup

    def initialize
        FileUtils.touch("#{DIR}/qwicky.yml")

        @conf = {
            'homepage' => 'Home',
            'markup' => 'text',
        }.merge(
            open("#{DIR}/qwicky.yml") { |f|
                YAML::load(f) || Hash.new
            }
        )

        set_markup
    end

    def set_markup
        catch :revert do
            @markup = Markup::Markup[@conf['markup']].new
            return
        end

        @markup = Markup::Markup['text'].new
    end
end

APP = Qwicky.new

# Routes. {{{1
helpers do
    def redirect_home
        redirect "/#{APP.conf['homepage']}"
    end

    def markup text
        APP.markup.format(text)
    end
end

get '/' do
    redirect_home
end

get '/.settings' do
    @settings = APP.conf
    @title = 'Settings'
    haml :settings
end

post '/.settings' do
    APP.conf.merge!(params[:settings])
    APP.set_markup
    open("#{DIR}/qwicky.yml", 'w') { |f|
        f.write(YAML::dump(APP.conf))
    }
    
    redirect_home
end

get '/.stylesheet.css' do
    sass :stylesheet
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

