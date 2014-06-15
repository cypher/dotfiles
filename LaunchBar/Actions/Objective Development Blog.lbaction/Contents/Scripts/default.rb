
require 'open-uri'
require 'rss'
require 'json'
require 'cgi'


# Load the RSS feed:
rss_content = ""
rss_url = "http://blog.obdev.at/feed/"
open(rss_url) do |file|
    rss_content = file.read
end

# Parse the RSS feed:
rss = RSS::Parser.parse(rss_content, false)

result = []

# Add an item on top that represents the feed itself:
item = {}
item['title'] = rss.channel.title
item['url'] = rss.channel.link
item['subtitle'] = rss.channel.link

# LaunchBar uses the action's bundle resources to find the image with that name:
item['icon'] = 'ObDev Logo'

result.push(item)

# Add an item for each item in the RSS feed:
rss.items.each do | rss_item |
    item = {}
    item['title'] = CGI.unescapeHTML(rss_item.title)
    item['url'] = rss_item.link
    item['icon'] = ''

    # Limit the length of the description, which is usually very long:
    max_description_length = 100
    description = CGI.unescapeHTML(rss_item.description)
    item['subtitle'] = description[0, max_description_length]
    item['subtitle'] += '…' if description.length > max_description_length

    result.push(item)
end

# Output the array of result items in JSON so LaunchBar can parse it:
puts result.to_json
