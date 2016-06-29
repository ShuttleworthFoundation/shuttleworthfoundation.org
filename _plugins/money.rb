class Numeric
  def to_currency( pre_symbol='$', thousands=',', decimal='.', post_symbol=nil )
    "#{pre_symbol}#{
      ( "%.2f" % self ).gsub(
        /(\d)(?=(?:\d{3})+(?:$|\.))/,
        "\\1#{thousands}"
      )
    }#{post_symbol}"
  end
end


module Jekyll
  module Money
    def money(number)
      if number.respond_to?(:to_currency)
        "#{number.to_currency}"
      else
        "#{number}"
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::Money)
