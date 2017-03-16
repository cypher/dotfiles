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
        say("Ignoring `#{file}'", :red) if options[:verbose]
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
    run("git submodule foreach git checkout master", verbose: options[:verbose])
    run("git submodule foreach git up", verbose: options[:verbose])
  end

  default_task :update

  no_commands do
    def basedir
      File.expand_path('..', __FILE__)
    end
  end

  desc "configure_macos", "Configures macOS-specific settings"
  def configure_macos
    # Apple Mail
    run("defaults write com.apple.mail DisableInlineAttachmentViewing -bool yes")
  end

  desc "configure", "Set OS-specific configurations"
  def configure
    case RUBY_PLATFORM
    when /darwin/
      if defined?("configure_macos")
        say("Found configure_macos")
        invoke "configure_macos"
      else
        say("No configuration task found for platform `macos'. Please define `configure_macos' first", :red)
      end
    when /freebsd/
      if defined?("configure_freebsd")
        invoke "configure_freebsd"
      else
        say("No configuration task found for platform `freebsd'. Please define `configure_freebsd' first", :red)
      end
    when /win32|cygwin|mswin|mingw|bccwin|wince|emx/
      if defined?("configure_windows")
        invoke "configure_windows"
      else
        say("No configuration task found for platform `windows'. Please define `configure_windows' first", :red)
      end
    when /linux/
      if defined?("configure_linux")
        invoke "configure_linux"
      else
        say("No configuration task found for platform `linux'. Please define `configure_linux' first", :red)
      end
    else
      say("Unknown OS/platform: #{RUBY_PLATFORM.inspect}", :red)
    end
  end
end
