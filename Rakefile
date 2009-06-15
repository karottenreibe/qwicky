require 'rake/clean'

CLEAN.include 'qwicky'
CLEAN.include 'qwicky.db'
CLEAN.include 'qwicky.yml'

task :compile do
    sh "cp qwicky.rb qwicky"

    open('qwicky', 'a') do |file|
        file.puts
        file.puts "__END__"
    end

    FileList['views/*'].each do |view|
        name = File.basename(view).ext()

        open('qwicky', 'a') do |file|
            file.puts
            file.puts "@@#{name}"
        end

        sh "cat #{view} >> qwicky"
    end

    open('qwicky', 'a') do |file|
        file.puts
        file.puts "@@favicon"
    end

    sh %q{echo -e ":plain\n`base64 favicon.png | sed 's/^/  /'`" >> qwicky}
end

