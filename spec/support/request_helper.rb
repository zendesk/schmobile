module RequestHelper

  def ipod
    'Mozilla/5.0 (iPod; U; CPU iPhone OS 2_2 like Mac OS X; en-us) AppleWebKit/525.18.1 (KHTML, like Gecko) Version/3.1.1 Mobile/5G77 Safari/525.20'
  end

  def iphone
    'Mozilla/5.0 (iPhone; U; CPU iPhone OS 3_1 like Mac OS X; en-us) AppleWebKit/528.18 (KHTML, like Gecko) Version/4.0 Mobile/7C144 Safari/528.16'
  end

  def android
    'Mozilla/5.0 (Linux; U; Android 2.0; ld-us; sdk Build/ECLAIR) AppleWebKit/530.17 (KHTML, like Gecko) Version/4.0 Mobile Safari/530.17'
  end

  def blackberry
    'BlackBerry9000/4.6.0.167 Profile/MIDP-2.0 Configuration/CLDC-1.1 VendorID/102'
  end

  def ipad
    'Mozilla/5.0 (iPad; U; CPU OS 3_2 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.4 Mobile/7B334b Safari/531.21.10'
  end

  def palm
    'Mozilla/5.0 (webOS/1.0; U; en-US) AppleWebKit/525.27.1 (KHTML, like Gecko) Version/1.0 Safari/525.27.1 Pre/1.0'
  end

  def samsung
    'Mozilla/4.0 (compatible; MSIE 6.0; BREW 3.1.5; en )/800x480 Samsung SCH-U960'
  end

  def htc_touch
    'HTC_Touch_Diamond2_T5353 Opera/9.50 (Windows NT 5.1; U; en)'
  end

  def danger
    'Mozilla/5.0 (Danger hiptop 5.0; U; rv:1.7.12) Gecko/20050920'
  end

  def msie6
    'Mozilla/4.0 (compatible; MSIE 6.0; Update a; AOL 6.0; Windows 98)'
  end

  def msie8
    'Client: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.0; WOW64; Trident/4.0; SLCC1; .NET CLR 2.0.50727; Media Center PC 5.0; MDDR; .NET CLR 3.5.30729; InfoPath.2; .NET CLR 3.0.30729; OfficeLiveConnector.1.3; OfficeLivePatch.0.0; .NET CLR 4.0.20506; Creative AutoUpdate v1.40.01)'
  end

  def chrome
    'Mozilla/5.0 (Windows NT 5.1) AppleWebKit/534.24 (KHTML, like Gecko) Chrome/11.0.696.71 Safari/534.24'
  end

  def opera
    'Opera/9.25 (Windows NT 6.0; U; en)'
  end

  def request(overwrite = {})
    Rack::Request.new(environment(overwrite))
  end

  def action_dispatch_request(overwrite = {})
    ActionDispatch::Request.new(environment(overwrite))
  end

  def environment(overwrite = {})
     {
       'GATEWAY_INTERFACE'=> 'CGI/1.2',
       'HTTP_ACCEPT'=> 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
       'HTTP_ACCEPT_CHARSET'=> 'ISO-8859-1,utf-8;q=0.7,*;q=0.7',
       'HTTP_ACCEPT_ENCODING'=> 'gzip,deflate',
       'HTTP_ACCEPT_LANGUAGE'=> 'en-us,en;q=0.5',
       'HTTP_CONNECTION'=> 'keep-alive',
       'HTTP_HOST'=> 'localhost:4567',
       'HTTP_KEEP_ALIVE'=> 300,
       'HTTP_USER_AGENT'=> 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.3) Gecko/20090920 Firefox/3.5.3 (Swiftfox)',
       'HTTP_VERSION'=> 'HTTP/1.1',
       'PATH_INFO'=> '/',
       'QUERY_STRING'=> '',
       'REMOTE_ADDR'=> '127.0.0.1',
       'REQUEST_METHOD'=> 'GET',
       'REQUEST_PATH'=> '/',
       'REQUEST_URI'=> '/',
       'SCRIPT_NAME'=> '',
       'SERVER_NAME'=> 'localhost',
       'SERVER_PORT'=> '4567',
       'SERVER_PROTOCOL'=> 'HTTP/1.1',
       'SERVER_SOFTWARE'=> 'Mongrel 1.1.5',
       'rack.multiprocess'=> false,
       'rack.multithread'=> true,
       'rack.request.form_hash'=> '',
       'rack.request.form_vars'=> '',
       'rack.request.query_hash'=> '',
       'rack.request.query_string'=> '',
       'rack.run_once'=> false,
       'rack.url_scheme'=> 'http',
       'rack.version'=> '1: 0'
     }.merge(overwrite)
   end

end
