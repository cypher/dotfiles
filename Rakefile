require 'etc'
require 'fileutils'

def basedir
  File.dirname(__FILE__)
end

def homedir
  if Dir.respond_to? :home
    Dir.home(Etc.getlogin)
  else
    # Less reliable, but only way supported on 1.8
    File.expand_path('~')
  end
end

IGNORED_ENTRIES = %w{install.sh Rakefile README.txt LICENSE bin etc example git-hooks postgresql LaunchBar LaunchAgents}

task :install_dotfiles do
  Dir[File.join(basedir, '*')].each do |entry|
    if File.file?(entry) or File.directory?(entry)
      basename = File.basename(entry)
      next if IGNORED_ENTRIES.include?(basename)

      target = File.join(homedir, ".#{basename}")

      File.unlink(target) if File.directory?(target) # We need to unlink directories before creating the symlink, otherwise Ruby will create it as "source/target" instead of "target"
      FileUtils.ln_sf(File.join(basedir, basename), target, :verbose => true)
    end
  end
end

task :install_bins do
  bindir = File.join(homedir, 'bin')
  bin_basedir = File.join(basedir, 'bin')

  FileUtils.mkdir(bindir, :verbose => true, :mode => 0700) unless File.exists?(bindir) and File.directory?(bindir)

  Dir[File.join(bin_basedir, '*')].each do |entry|
    basename = File.basename(entry)

    FileUtils.ln_sf(File.join(bin_basedir, basename), File.join(bindir, basename), :verbose => true)

    if basename == 'git-up'
      FileUtils.ln_sf(File.join(bindir, 'git-up'), File.join(bindir, 'git-reup'), :verbose => true)
    end
  end
end

task :install => [ :install_dotfiles, :install_bins ]

task :update do
  system("git submodule foreach git up")

  rust_dir = File.expand_path('~/src/rust')
  Dir.chdir(rust_dir) do
    FileUtils.cp_r(Dir.glob(File.join(rust_dir, 'src/etc/vim/*')), File.join(basedir, 'vim/bundle/rust/'), :verbose => true)
  end if File.exists?(rust_dir)
end

task :default => [ :update ]
