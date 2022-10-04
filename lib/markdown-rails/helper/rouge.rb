require "rouge"

module MarkdownRails
  module Helper
    module Rouge
      def rouge_theme
        "gruvbox".freeze
      end

      def rouge_formatter
        ::Rouge::Formatters::HTMLInline.new(rouge_theme)
      end

      def rouge_fallback_lexer
        rouge_lexer "text"
      end

      def highlight_code(code, language)
        lexer = rouge_lexer(language) || rouge_fallback_lexer
        rouge_formatter.format(lexer.lex(code))
      end

      def block_code(code, language)
        content_tag :pre, class: language do
          raw highlight_code code, language
        end
      end

      def rouge_lexer(language)
        ::Rouge::Lexer.find language
      end
    end
  end
end
