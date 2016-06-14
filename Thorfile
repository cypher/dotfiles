require 'fileutils'

class Dotfiles < Thor
  include Thor::Actions
  Thor::Sandbox::Dotfiles.source_root(File.expand_path('..', __FILE__))

  IGNORED_ENTRIES = %w{install.sh Rakefile Thorfile README.md LICENSE bin etc example git-hooks postgresql LaunchBar LaunchAgents Brewfile Misc}

  desc "install_dotfiles", "Installs all dotfiles"
  method_options verbose: true
  def install_dotfiles
    Dir['*'].each do |file|
      if IGNORED_ENTRIES.include?(file)
        say("Skipping file `#{file}'...", :red) if options[:verbose]
        next
      end

      link_target = File.join(Thor::Util.user_home, ".#{file}")
      link_source = File.join(basedir, file)

      link_file(link_source, link_target, verbose: options[:verbose])
    end
  end

  desc "install_bin", "Installs all bin scripts and commands"
  method_options verbose: true
  def install_bin
    bindir = File.join(Thor::Util.user_home, 'bin')
    bin_basedir = File.join(basedir, 'bin')

    FileUtils.mkdir(bindir, :verbose => true, :mode => 0700) unless File.exists?(bindir) and File.directory?(bindir)

    Dir[File.join(bin_basedir, '*')].each do |entry|
      basename = File.basename(entry)

      link_target = File.join(bindir, basename)
      link_source = File.join(bin_basedir, basename)

      link_file(link_source, link_target, verbose: options[:verbose])

      if basename == 'git-up'
        link_file(File.join(bindir, 'git-up'), File.join(bindir, 'git-reup'), verbose: options[:verbose])
      end
    end
  end

  desc "install", "Installs all dotfiles and bin scripts/commands"
  method_options verbose: true
  def install
    invoke "install_dotfiles", verbose: options[:verbose]
    invoke "install_bin", verbose: options[:verbose]
  end

  desc "update", "Update all submodules, e.g. for Vim bundles"
  method_options verbose: true
  def update
    run("git submodule foreach git checkout master", verbose: options[:verbose], capture: true)
    run("git submodule foreach git up", verbose: options[:verbose], capture: true)
  end

  default_task :update

  no_commands do
    def basedir
      File.expand_path('..', __FILE__)
    end
  end
end
