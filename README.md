# Schmobile [![Build Status](https://secure.travis-ci.org/zendesk/schmobile.png)](http://travis-ci.org/zendesk/schmobile)

A mobile user agent detection Rack middleware. It provides `Rack::Request#is_mobile?`

## Forcing mobile mode

You can force toggle mobile mode by sending +is_mobile#true+ and +is_mobile#false+ as
parameters in the request URL. This setting will be stored in the session for subsequent requests.
This entirely overrides the user agent detection.

## User agent detection

You can add/remove user agents like so:

```ruby
Schmobile::UserAgents.add_user_agent_pattern("wibble")
Schmobile::UserAgents.remove_user_agent_pattern("ipad")
```

## Filters

The outcome of the +request.is_mobile?+ call is the product of a series of filters getting evaluated
against the request. You can manipulate the Schmobile::Filters::CHAIN array to alter if a
request is deemed mobile or not. Add your own filter to bypass the check depending on e.g. location
or request format.

## Redirecting

It can be configured to return the user to an explicit destination:

```ruby
use Schmobile, :redirect_to => "/mobile"
```

It supports string interpolation for dynamic destinations:

```ruby
use Schmobile, :redirect_to => "/mobile/#!/{{path}}"
```

Finally the middleware provides a request level method to determine if the client is a mobile device

```ruby
Rack::Request#is_mobile?
```

## Rolling out

```ruby
use Schmobile, :redirect_to => "/mobile", :if => Proc.new { |request| request.host =~ /staging/ }
```

## Copyright and license

Copyright 2013 Zendesk

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
