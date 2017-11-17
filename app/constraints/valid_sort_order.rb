class ValidSortOrder
  def self.matches?(request)
    return true if request.parameters['sortby'].nil?
    sortby = request.parameters['sortby']
    sortby.in?(Post::VALID_SORT_ORDERS)
  end
end