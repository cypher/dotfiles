require 'etc'
require 'fileutils'

def basedir
  File.dirname(__FILE__)
end

def homedir
  Dir.home(Etc.getlogin)
end

IGNORED_ENTRIES = %w{install.sh Rakefile README.txt LICENSE bin etc example git-hooks postgresql LaunchBar LaunchAgents}

task :install_dotfiles do
  Dir[File.join(basedir, '*')].each do |entry|
    if File.file?(entry)
      basename = File.basename(entry)
      next if IGNORED_ENTRIES.include?(basename)

      FileUtils.ln_sf(File.join(basedir, basename), File.join(homedir, ".#{basename}"), verbose: true)
    end
  end
end

task :install_bins do
  bindir = File.join(homedir, 'bin')
  bin_basedir = File.join(basedir, 'bin')

  FileUtils.mkdir(bindir, verbose: true, mode: 0700) unless File.exists?(bindir) and File.directory?(bindir)

  Dir[File.join(bin_basedir, '*')].each do |entry|
    basename = File.basename(entry)

    FileUtils.ln_sf(File.join(basedir, basename), File.join(bindir, basename), verbose: true)

    if basename == 'git-up'
      FileUtils.ln_sf(File.join(bindir, 'git-up'), File.join(bindir, 'git-reup'), verbose: true)
    end
  end
end

task :install => [:install_dotfiles, :install_bins]

task :default => [ :install ]
