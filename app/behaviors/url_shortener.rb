module UrlShortener
  class << self
    def create_short_link(url)
      client.shorten(url).short_url
    end

    def get_stats(short_url)
      client.clicks(short_url).user_clicks
    end

    def client
      Bitly.use_api_version_3
      Bitly.new(BITLY_USERNAME, BITLY_API_KEY)
    end
  end
end
