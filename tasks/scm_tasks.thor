require 'find'

class Scm < Thor

  desc "fetch", "Fetches the newest updates for all repositories (git, svn, bzr, hg, darcs) in your current working directory and its subdirectories"
  def fetch
    #run_pager
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
    #run_pager
    find_scm_dirs(File.expand_path(Dir.getwd)) do |scm|
      case scm
      when ".svn"
        system("svn up")
      when ".git"
        unless git_svn?
          system("git remote update")
          system("git pull")
        else
          system("git svn fetch")
          system("git svn rebase")
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

  desc "gc", "Executes git gc on all git repos"
  method_options :aggressive => :boolean
  def gc()
    #run_pager
    find_scm_dirs(File.expand_path(Dir.getwd)) do |scm|
      if scm == ".git"
        if options[:aggressive]
          system("git gc --aggressive --prune=now")
        else
          system("git gc --auto")
        end
      end
    end
  end

  private

  SUPPORTED_SCMS = [".git", ".svn", ".bzr", ".hg", "_darcs"]

  def check_for_scm(path)
    Dir.glob(File.join(path, "*"), File::FNM_DOTMATCH).each do |file_or_dir|
      if File.directory?(file_or_dir) then
        dir = File.split(file_or_dir)[1]
        return dir if SUPPORTED_SCMS.include?(dir)
      end
    end
    false
  end

  def find_scm_dirs(path, &block)
    if scm = check_for_scm(path) then
      Dir.chdir(path) do
        puts("(in #{path})")
        yield scm
      end
    else
      Dir[File.join(path, "*")].each do |path|
        find_scm_dirs(path, &block) if File.directory?(path)
      end
    end
  end

  def git_svn?
    File.exist?(".git/config") && !File.readlines(".git/config").grep(/^\[svn-remote "svn"\]\s*$/).empty?
  end

  def run_pager
    return if PLATFORM =~ /win32/
    return unless STDOUT.tty?

    read, write = IO.pipe

    unless Kernel.fork # Child process
      STDOUT.reopen(write)
      STDERR.reopen(write) if STDERR.tty?
      read.close
      write.close
      return
    end

    # Parent process, become pager
    STDIN.reopen(read)
    read.close
    write.close

    ENV['LESS'] = 'FSRX' # Don't page if the input is short enough

    Kernel.select [STDIN] # Wait until we have input before we start the pager
    pager = ENV['PAGER'] || 'less'
    exec pager rescue exec "/bin/sh", "-c", pager
  end
end
