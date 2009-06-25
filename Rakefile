require 'rake/clean'

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

task :release => [:clean, :compile] do
    sh "vim HISTORY.markdown"
    sh "vim README.markdown"
    sh "vim qwicky.gemspec"

    print "Enter the new version number >> "
    version = $stdin.gets.strip

    unless version =~ %r{[0-9]+\.[0-9]+\.[0-9]+}
        puts "Aborting: Invalid version number given."
        exit -1
    end
    
    puts "Committing"
    sh "git commit -a -m 'Releasing v#{version}'"
    puts "Tagging"
    sh "git tag #{version}"
    puts "Pushing"
    sh "git push"
    puts "Pushing tags"
    sh "git push --tags"

    puts "Done!"
end

