# Wor::Paginate
[![Build Status](https://travis-ci.org/Wolox/wor-paginate.svg?branch=master)](https://travis-ci.org/Wolox/wor-paginate)
[![Gem Version](https://badge.fury.io/rb/wor-paginate.svg)](https://badge.fury.io/rb/wor-paginate)
[![Dependency Status](https://gemnasium.com/badges/github.com/Wolox/wor-paginate.svg)](https://gemnasium.com/github.com/Wolox/wor-paginate)
[![Code Climate](https://codeclimate.com/github/Wolox/wor-paginate/badges/gpa.svg)](https://codeclimate.com/github/Wolox/wor-paginate)
[![Test Coverage](https://codeclimate.com/github/Wolox/wor-paginate/badges/coverage.svg)](https://codeclimate.com/github/Wolox/wor-paginate/coverage)

Wor::Paginate is a gem for Rails that simplifies pagination, particularly for controller methods, while standardizing JSON output for APIs. It's meant to work both as a standalone pagination gem and as an extra layer over [Kaminari](https://github.com/kaminari/kaminari) and [will_paginate](https://github.com/mislav/will_paginate).

## Installation
Add the following line to your application's Gemfile:

```ruby
gem 'wor-paginate'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install wor-paginate
```

Then you can run `rails generate wor:paginate:install` to create the initializer for configuration details, including default formatter class, page and limit params and default page number.

## Usage
### Basic usage
The basic use case is to paginate using default values. This is achieved by including the module in a controller and calling render_paginate in the method that needs pagination.
```ruby
  class DummyModelsController < ApplicationController
    include Wor::Paginate

    def index
        render_paginated DummyModel
    end
  end
```
The first parameter to render_paginated can be multiple things:
* ActiveRecord/ActiveRecord::Relation
* Enumerables (for example, arrays and ranges)
* Pre-paginated Kaminari or will_paginate relations (original pagination will be ignored)

The response to the index will then be:
```json
{
  "page": [
    {
      "id": 1,
      "name": "1c",
      "something": 27
    },
    {
      "id": 2,
      "name": "i",
      "something": 68
    },
    ...
    {
      "id": 25,
      "name": "2m",
      "something": 32
    }
  ],
  "count": 25,
  "total_pages": 2,
  "total_count": 28,
  "current_page": 1,
  "next_page": 2
}
```

Page number is passed through the `page` option of the `render_paginated` method. If none is supplied, `params[:page]` will be used, (or the default parameter configured in the initializer).
By default, if the page parameter is not present we will use 1 as the page (or the default `page` parameter configured in the initializer).
The amount of items is passed through the `limit` option of the `render_paginated` method. If none is supplied, `params[:limit]` will be used (or the default parameter configured in the initializer). Default is 25.
The default serializer and formatter will be used.

### Customizing output
#### Custom serializers
A custom serializer for each object can be passed using the `each_serializer` option:
```ruby
render_paginated DummyModel, each_serializer: CustomDummyModelSerializer
```
where the serializer is just an [`ActiveModel::Serializer`](https://github.com/rails-api/active_model_serializers).

#### Custom formatters
A formatter is an object that defines the output of the render_paginated method. In case the application needs a different format for a request, it can be passed to the `render_paginated` method using the `formatter` option:
```ruby
render_paginated DummyModel, formatter: CustomFormatter
```
or it can also be set as a default in the initializer.

A new formatter can be created inheriting from the default one. The `format` method should be redefined returning something that can be converted to json.

```ruby
class CustomFormatter < Wor::Paginate::Formatter
  def format
    { page: serialized_content, current: current_page }
  end
end
```

Available helper methods are:
* `current_page`: integer with the current page
* `count`: number of items in the page (post-pagination)
* `total_count`: number of total items (pre-pagination)
* `total_pages`: number of pages given the current limit (post-pagination)
* `paginated_content`: its class depends on the original content passed to render_paginated, it's the paginated but not yet serialized content.
* `serialized_content`: array with all the items after going through the serializer (either the default or a supplied one)

### Working with Kaminari or will_paginate
If either Kaminari or will_paginate are required in the project, Wor::Paginate will use them for pagination with no code or configuration change.

### Test helpers
You can use the `be_paginated` matcher to test your endpoints. It also accepts the `with` chain method to receive a formatter.

You only need to add this in your rails_helper.rb
```
# spec/rails_helper.rb
require 'wor/paginate/rspec'
```
And in your spec do
```
# spec/controllers/your_controller.rb
describe YourController do
  describe '#index' do
    it 'checks that the response keys matches with the default formatter' do
      get :index
      expect(response_body(response)).to be_paginated
    end
  end

  describe '#index_with_custom_formatter' do
    it 'checks that the response keys matches with the custom formatter' do
      get :index_custom_formatter
      expect(response_body(response)).to be_paginated.with(CustomFormatter)
    end
  end
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Run rubocop lint (`bundle exec rubocop -R --format simple`)
5. Run rspec tests (`bundle exec rspec`)
6. Push your branch (`git push origin my-new-feature`)
7. Create a new Pull Request

## About ##

This project is maintained by [Hugo Farji](https://github.com/hdf1986), [Ignacio Coluccio](https://github.com/icoluccio), and [Alan Halatian](https://github.com/alanhala). It was written by [Wolox](http://www.wolox.com.ar).
![Wolox](https://raw.githubusercontent.com/Wolox/press-kit/master/logos/logo_banner.png)

## License

**wor-paginate** is available under the MIT [license](https://raw.githubusercontent.com/Wolox/wor-paginate/master/LICENSE.md).

    Copyright (c) 2017 Wolox

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
