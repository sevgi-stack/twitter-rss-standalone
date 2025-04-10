require 'twitter'
require 'rss'

# Configure your Twitter API credentials
client = Twitter::REST::Client.new do |config|
  config.consumer_key        = 'YOUR_CONSUMER_KEY'
  config.consumer_secret     = 'YOUR_CONSUMER_SECRET'
  config.access_token        = 'YOUR_ACCESS_TOKEN'
  config.access_token_secret = 'YOUR_ACCESS_TOKEN_SECRET'
end

# Replace 'TARGET_ACCOUNT' with the Twitter account or hashtag you want to follow
target_account = 'TARGET_ACCOUNT'

# Fetch tweets from the target account or hashtag
tweets = client.user_timeline(target_account, count: 10)

# Create an RSS feed
rss_feed = RSS::Maker.make('atom') do |maker|
  maker.channel.author = target_account
  maker.channel.updated = Time.now

  tweets.each do |tweet|
    maker.items.new_item do |item|
      item.title = tweet.text
      item.link = "https://twitter.com/#{tweet.user.screen_name}/status/#{tweet.id}"
      item.updated = tweet.created_at
    end
  end
end

# Print the RSS feed to the console or save it to a file
puts rss_feed.to_s
