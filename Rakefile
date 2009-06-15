require 'rake/clean'

CLEAN.include 'bin/qwicky'
CLEAN.include 'qwicky.db'
CLEAN.include 'qwicky.yml'

directory 'bin'

task :compile => ['bin'] do
    sh "cp qwicky.rb bin/qwicky"

    open('bin/qwicky', 'a') do |file|
        file.puts
        file.puts "# Templates. {{" + "{1"
        file.puts "__END__"
    end

    FileList['views/*'].each do |view|
        name = File.basename(view).ext()

        open('bin/qwicky', 'a') do |file|
            file.puts
            file.puts "@@#{name}"
        end

        sh "cat #{view} >> bin/qwicky"
    end

    open('bin/qwicky', 'a') do |file|
        file.puts
        file.puts "@@favicon"
    end

    sh %q{echo -e ":plain\n`base64 favicon.png | sed 's/^/  /'`" >> bin/qwicky}
end

