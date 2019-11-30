module ApplicationHelper
  def json_syntax(content)
    formatter = Rouge::Formatters::HTMLLegacy.new(css_class: "highlight", inline_theme: Rouge::Themes::ThankfulEyes)
    lexer = Rouge::Lexers::JSON.new
    formatter.format(lexer.lex(content)).html_safe
  end
end
