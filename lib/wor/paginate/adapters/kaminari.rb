# Used when render_paginated is called with an ActiveModel directly, with kaminari
# already required. Something like
### render_paginated DummyModel
module Wor
  module Paginate
    module Adapters
      class Kaminari
        attr_reader :page

        def initialize(content, page, limit)
          @content = content
          @page = page
          @limit = limit
        end

        def adapt?
          %i[page per].all? do |method|
            @content.respond_to? method
          end
        end

        def paginated_content
          @paginated_content ||= @content.page(@page).per(@limit)
        end

        def count
          paginated_content.count
        end

        def total_count
          paginated_content.total_count
        end
      end
    end
  end
end