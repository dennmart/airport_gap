module ApplicationHelper
  def json_syntax(content)
    formatter = Rouge::Formatters::HTMLLegacy.new(css_class: 'highlight', inline_theme: Rouge::Themes::ThankfulEyes)
    lexer = Rouge::Lexers::JSON.new
    formatter.format(lexer.lex(content)).html_safe # rubocop:disable Rails/OutputSafety
  end

  def captcha
    data_attributes = {
      sitekey: ENV.fetch('CF_TURNSTILE_SITE_KEY', '1x00000000000000000000AA')
    }

    content_tag :div, nil, class: 'cf-turnstile', data: data_attributes
  end
end
