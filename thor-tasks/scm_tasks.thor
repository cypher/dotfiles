require 'find'

class Scm < Thor

  desc "fetch", "Fetches the newest updates for all repositories (git, svn, bzr, hg, darcs) in your current working directory and its subdirectories"
  def fetch
    find_scm_dirs(File.expand_path(Dir.getwd)) do |scm|
      case scm
      when ".svn"
        system("svn up")
      when ".git"
        unless git_svn?
          system("git remote update")
        else
          system("git svn fetch")
        end
      when ".bzr"
        system("bzr update")
      when ".hg"
        system("hg pull")
      when "_darcs"
        system("darcs pull --all")
      end
    end
  end

  desc "update", "Updates all repositories (git, svn, bzr, hg, darcs) in your current working directory and its subdirectories"
  def update
    find_scm_dirs(File.expand_path(Dir.getwd)) do |scm|
      case scm
      when ".svn"
        system("svn up")
      when ".git"
        if git_svn?
          system("git svn fetch")
          system("git svn rebase")
        else
          system("git remote update")
          system("git pull") unless git_bare?
        end
      when ".bzr"
        system("bzr pull")
      when ".hg"
        system("hg pull -u")
      when "_darcs"
        system("darcs pull --all")
      end
    end
  end

  desc 'up', "An alias for 'update'"
  alias :up :update

  desc "gc", "Executes git gc on all git repos"
  method_options :aggressive => :boolean
  def gc()
    find_scm_dirs(File.expand_path(Dir.getwd)) do |scm|
      if scm == ".git"
        if options[:aggressive]
          system("git gc --aggressive --prune=now")
        else
          system("git gc --prune=now")
        end
      end
    end
  end

  private

    SUPPORTED_SCMS = [".git", ".svn", ".bzr", ".hg", "_darcs"]

    def check_for_scm(path)
      Dir.glob(File.join(path, "*"), File::FNM_DOTMATCH).each do |file_or_dir|
        if File.directory?(file_or_dir)
          dir = File.split(file_or_dir)[1]
          return dir if SUPPORTED_SCMS.include?(dir)
          return '.git' if file_or_dir =~ /\.git\/\.$/
        end
      end
      false
    end

    def find_scm_dirs(path, &block)
      if scm = check_for_scm(path) then
        Dir.chdir(path) do
          say "(in #{path})", :green
          yield scm
        end
      else
        Dir[File.join(path, "*")].each do |path|
          find_scm_dirs(path, &block) if File.directory?(path)
        end
      end
    end

    def git_svn?
      (File.exist?('.git/config') && !File.readlines('.git/config').grep(/^\[svn-remote "svn"\]\s*$/).empty?) ||
        (File.exist?('config') && File.file?('config') && !File.readlines('config').grep(/^\[svn-remote "svn"\]\s*$/).empty?)
    end

    def git_bare?
      File.exists?('config') && File.file?('config') && File.exists?('HEAD')
    end
end
