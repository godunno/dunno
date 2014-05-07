Apipie::ApipiesController.class_eval do
  before_filter only: :index do
    @should_extract_params_from_examples = true
  end

  def render(*args)
    extract_params_from_examples if @should_extract_params_from_examples
    super
  end

  def param_hash(param, value)
    {
      name: param,
      full_name: param,
      show: true,
      description: "Ex.: #{value}"
    }
  end

  def params_names(parameters)
    parameters.map do |p|
      result = [p[:full_name]]
      if p[:params]
        result += params_names(p[:params])
      end
      result
    end.flatten
  end

  def extract_params_from_examples
    if @resource
      @resource[:methods].each_with_index do |m, i|
        if m[:examples].any?
          query = if m[:examples][0] =~ /^GET/ # params as a querystring
                    URI.parse(m[:examples][0].lines[0].sub('GET', '').strip).query
                  else # params in the request body
                    m[:examples][0].lines[1].strip
                  end
          if query
            p = CGI.parse(query)
            p = p.map do |param, value|
              param_hash(param, value)
            end
            p.reject! { |q| params_names(m[:params]).include?(q[:full_name]) }
            @resource[:methods][i][:params] += p
          end
        end
      end
    end
  end
end
