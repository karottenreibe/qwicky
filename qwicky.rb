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

# Read working dir. {{{1
idx = ARGV.index { |arg| arg == '--' }
DIR = File.expand_path(
    if idx.nil? or ARGV[idx+1].nil?
        Dir.pwd
    else
        ARGV[idx+1]
    end
)

unless File.exist?(DIR) and File.directory?(DIR)
    puts "No such directory: #{DIR}"
    exit -1
end

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
    # Base class. {{{2
    class Markup
        class << self
            attr_reader :description, :link

            def markups
                @@markups
            end

            def [] type
                @@markups ||= Hash.new
                @@markups[type]
            end

            def type id, description, link = nil
                @@markups ||= Hash.new
                @@markups[id] = self
                @description = description
                @link = link
            end
        end

        def description
            self.class.description
        end

        def link
            self.class.link
        end

        def format text
            text
        end
    end

    # Text. {{{2
    class MText < Markup
        type 'text', 'Simple text'

        def format text
            "<span style='white-space:pre'>#{text}</span>"
        end
    end

    # Markdown. {{{2
    class MMarkdown < Markup
        type 'markdown', 'Markdown', 'http://daringfireball.net/projects/markdown/'

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

    # Textile. {{{2
    class MTextile < Markup
        type 'textile', 'Textile', 'http://textism.com/tools/textile/'

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

    # RDoc. {{{2
    class MRDoc < Markup
        type 'rdoc', 'RDoc', 'http://rdoc.sourceforge.net/doc/index.html'
        
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
            'homepage' => '',
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

    def format text
        markup.format(text).gsub %r{\[\[([^|\]]+)(\|([^\]]+))?\]\]} do |match|
            page = $3 || $1
            nexist = Page.first(:name => page).nil?
            klass = nexist ? 'bad' : 'good'
            title = nexist ? "Create page #{page}" : "Page #{page}"
            link = '/' + page
            "<a href=#{link.inspect} title=#{title.inspect} class='#{klass}'>#{$1}</a>"
        end
    end
end

APP = Qwicky.new

# Routes. {{{1
helpers do
    def redirect_home
        if APP.conf['homepage'].empty?
            redirect "/..settings"
        else
            redirect "/#{APP.conf['homepage']}"
        end
    end

    def markup text
        APP.format(text)
    end
end

before do
    @editable = true
end

get '/' do
    redirect_home
end

get '/..settings/?' do
    @editable = false
    @settings = APP.conf
    @title = 'Settings'
    @markups = Markup::Markup.markups
    haml :settings
end

post '/..settings/?' do
    APP.conf.merge!(params[:settings])
    APP.set_markup
    open("#{DIR}/qwicky.yml", 'w') { |f|
        f.write(YAML::dump(APP.conf))
    }
    
    redirect_home
end

get '/..license/?' do
    content_type 'text'
    open('LICENSE').read
end

get '/..stylesheet.css' do
    content_type 'text/css'
    sass :stylesheet
end

get '/..user.stylesheet.css' do
    content_type 'text/css'

    if File.exist?("#{DIR}/qwicky.sass")
        sass open("#{DIR}/qwicky.sass").read()
    else
        ''
    end
end

get '/..sitemap' do
    @editable = false
    @title = 'Sitemap'
    @pages = Page.all.sort_by { |page| page.name }
    haml :sitemap
end

get '/:page/?' do |page|
    @page = Page.first(:name => page)
    redirect "/#{page}/edit" if @page.nil?
    @title = page
    haml :page
end

get '/:page/edit/?' do |page|
    @markup = APP.markup
    @page = Page.first(:name => page) || Page.new(:name => page)
    @title = "Editing #{page}"
    haml :edit
end

post '/:page/?' do |page|
    @page = Page.first(:name => page) || Page.new
    @page.name = params[:name]
    @page.content = params[:content]
    @page.save

    redirect "/#{page}"
end

delete '/:page/?' do |page|
    page = Page.first(:name => page)
    page.destroy unless page.nil?

    redirect_home
end

