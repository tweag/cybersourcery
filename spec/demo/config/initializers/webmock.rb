# WebMock is included for use in the Sinatra app running the proxy server. We don't want to run it
# here in the main app
#WebMock.disable!
WebMock.allow_net_connect!
