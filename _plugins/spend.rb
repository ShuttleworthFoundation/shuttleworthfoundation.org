module Jekyll
  module Spend

    def spend_year(spend, year)
      {year => spend[year]}
    end
    
    def spend_total(spend, contribution=0)
      if not spend.respond_to?(:each)
        0
      end
      
      $total = 0

      spend.each do |year, categories|
        categories.each do |category, amount|
          $total += amount
        end
      end

      if contribution
        return ($total - contribution)
      end

      return ($total)

    end
  end
end

Liquid::Template.register_filter(Jekyll::Spend)
