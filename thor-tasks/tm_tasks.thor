class Tm < Thor
  desc 'update', 'Update all installed TextMate user bundles'
  def update
    bundles_path = File.expand_path('~/Library/Application Support/TextMate/Bundles')
    if File.exist?(bundles_path)
      Dir.chdir(bundles_path) do |dir|
        invoke 'scm:update'
        say "Reloading bundles...", :green
        system %q{osascript -e 'tell app "TextMate" to reload bundles'}
      end
    end
  end

  desc 'up', "An alias for 'update'"
  alias :up :update
end
