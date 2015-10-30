module Jekyll
  module GroupByYearFilter
    
    def groupable?(element)
      element.respond_to?(:group_by)
    end
    
    # Group an array of items by the year of a date.
    #
    # input - the inputted Enumerable
    # property - the date property
    #
    # Returns an array of Hashes, each looking something like this:
    #  {"year"  => 2015
    #   "items" => [...] } # all the items where date.strftime('%Y') == "2015"
    def group_by_year(input, property)
      if groupable?(input)
        input.group_by do |item|
          if item_property(item, property).respond_to?(:strftime)
            item_property(item, property).strftime("%Y")
          else
            "Unknown"
          end
        end.inject([]) do |memo, i|
          memo << {"year" => i.first, "items" => i.last}
        end
      else
        input
      end
    end
    
    # Sort an array of objects
    #
    # input - the object array
    # property1 - property within each object to sort by primarily
    # property2 - property within each object to sort by secondarily
    #
    # Returns the sorted array of objects
    def sort_two(input, property1, property2)
      if input.nil?
          raise ArgumentError.new("Cannot sort a null object.")
      end

      input.sort { |apple, orange|
        apple_p1 = item_property(apple, property1)
        apple_p2 = item_property(apple, property2)
        orange_p1 = item_property(orange, property1)
        orange_p2 = item_property(orange, property2)
        
        [apple_p1, apple_p2] <=> [orange_p1, orange_p2]
      }
    end
    
  end
end

Liquid::Template.register_filter(Jekyll::GroupByYearFilter)



