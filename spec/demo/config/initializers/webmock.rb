# WebMock is included in the gemspec for use in the Sinatra app running the proxy server. We don't
# want to run it here in the main app.
WebMock.disable! if defined? WebMock
