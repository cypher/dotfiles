require 'find'

class Scm < Thor
  include Thor::Actions

  desc "fetch [DIRNAME]", "Fetches the newest updates for all repositories (git, svn, bzr, hg, darcs) in DIRNAME or your current working directory and its subdirectories"
  def fetch(dirname = nil)
    dir = dirname || Dir.getwd
    find_scm_dirs(File.expand_path(dir)) do |scm|
      case scm
      when ".svn"
        run("svn up")
      when ".git"
        if git_svn?
          run("git svn fetch")
        else
          run("git remote update")
        end
      when ".bzr"
        run("bzr update")
      when ".hg"
        run("hg pull")
      when "_darcs"
        run("darcs pull --all")
      end
    end
  end

  desc "update [DIRNAME]", "Updates all repositories (git, svn, bzr, hg, darcs) in DIRNAME or your current working directory and its subdirectories"
  method_options aliases: "up"
  def update(dirname = nil)
    dir = dirname || Dir.getwd
    find_scm_dirs(File.expand_path(dir)) do |scm|
      case scm
      when ".svn"
        run("svn up")
      when ".git"
        if git_svn?
          run("git svn fetch")
          run("git svn rebase")
        else
          run("git remote update")
          unless git_bare?
            if File.executable?(File.expand_path("~/bin/git-up"))
              run("git up")
            else
              run("git pull --progress --summary --stat --ff-only ")
            end
          end
        end
      when ".bzr"
        run("bzr pull")
      when ".hg"
        run("hg pull -u")
      when "_darcs"
        run("darcs pull --all")
      end
    end
  end

  desc "gc [DIRNAME]", "Executes git gc on all git repos"
  method_options aggressive: false
  def gc(dirname = nil)
    dir = dirname || Dir.getwd
    find_scm_dirs(File.expand_path(dir)) do |scm|
      if scm == ".git"
        if options[:aggressive]
          run("git gc --aggressive --prune=now")
        else
          run("git gc --prune=now")
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
        Dir[File.join(path, "*")].each do |dir_path|
          find_scm_dirs(dir_path, &block) if File.directory?(dir_path)
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
