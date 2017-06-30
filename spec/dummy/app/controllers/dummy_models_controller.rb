class DummyModelsController < ApplicationController
  include Wor::Paginate

  def index
    render_paginated DummyModel
  end

  def index_scoped
    render_paginated DummyModel.some_scope
  end

  def index_array
    render_paginated [1, 2, 3, 4, 5, 6, 7]
  end

  def index_exception
    render_paginated 5
  end

  def index_kaminari
    render_paginated DummyModel.page(1).per(5)
  end

  def index_will_paginate
    render_paginated DummyModel.paginate(page: 1, per_page: 5)
  end
end