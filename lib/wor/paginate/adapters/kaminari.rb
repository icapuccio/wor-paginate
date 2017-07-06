# Used when render_paginated is called with an ActiveModel directly, with kaminari
# already required. Something like
### render_paginated DummyModel
module Wor
  module Paginate
    module Adapters
      class Kaminari < Wor::Paginate::Adapters::Adapter
        def required_methods
          %i(page)
        end

        def paginated_content
          @paginated_content ||= @content.page(@page).per(@limit)
        end

        delegate :total_pages, :count, :total_count, to: :paginated_content
      end
    end
  end
end
