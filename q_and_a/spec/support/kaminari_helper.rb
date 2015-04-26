def kaminari_stubs_to(object, opts = {})
  default_opts = { current_page: 1, limit_value: 25, total_pages: 3 }
  opts.merge!(default_opts)
  unless opts[:total_count]
    opts[:total_count] = object.count rescue 0
  end

  opts.each do |method, value|
    allow(object).to receive(method.to_sym).and_return value
  end

  object
end
