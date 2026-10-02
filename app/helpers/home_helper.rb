module HomeHelper
  HTTP_REQUEST_LINE = %r{\A(GET|POST|PUT|PATCH|DELETE) \S+ HTTP/[\d.]+\z}
  HTTP_HEADER_LINE = /\A([A-Za-z-]+:)( .*)\z/

  # Renders a raw HTTP example one line per element, so long lines wrap with a
  # hanging indent instead of looking like new lines on narrow screens. Lines
  # starting with `highlight` render as <mark> to call out what changed.
  def http_example(text, highlight: nil)
    lines = text.chomp.split("\n", -1).map do |line|
      content = line.lstrip
      indent = line.length - content.length
      tag_name = highlight && content.start_with?(highlight) ? :mark : :span

      content_tag(tag_name, http_example_line(content), class: 'line', style: "--indent: #{indent}ch")
    end

    safe_join(lines)
  end

  private

  def http_example_line(content)
    return ' ' if content.empty?
    return content_tag(:span, content, class: 'http-start') if content.match?(HTTP_REQUEST_LINE)

    match = content.match(HTTP_HEADER_LINE)
    return content unless match

    safe_join([content_tag(:span, match[1], class: 'http-header'), match[2]])
  end
end
