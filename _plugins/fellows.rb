module Fellows
  class Generator < Jekyll::Generator
    def set_positions(events)
      # Find the first and last events.
      first_date = Date.today()
      last_date = Date.new()
      
      events.each do |item|
        if item['date'] < first_date
          first_date = item['date']
        end
        if item['date'] > last_date
          last_date = item['date']
        end
      end

      # Calculate required labels.
      labels = []
      first_label = ( first_date - 50 ).year + 1
      last_label = (last_date + 50 ).year
      (first_label .. last_label).each do |year|
        date = Date.new(year, 1, 1)
        labels.push({'date' => date, 'text' => year.to_s})
      end

      # Add a bit of space to both sides of the timeline.
      first_date -= 100
      last_date += 100

      # Calculate the position for each label and event.
      duration = last_date.mjd - first_date.mjd
      labels.each do |item|
        item['position'] = ( item['date'].mjd - first_date.mjd ) * 100 / duration
      end
      events.each do |item|
        item['position'] = ( item['date'].mjd - first_date.mjd ) * 100 / duration
      end

      return [
        events.sort_by { |event| event['position'] },
        labels.sort_by { |label| label['position'] }
      ]
    end
    
    def generate(site)
      site.collections['fellows'].docs.each do |post|
        if post.data['layout'] == 'fellow'
          events = []
          
          if post.data.key?('fellowship')
            fellowship = post.data['fellowship']
          else
            fellowship = {}
          end

          # Add flash grants that the fellow received.
          site.data['flashgrants'].each do |grant|
            if grant['name'] == post.data['fullname']
              events.push({'date' => grant['date'], 'text' => 'Flash grant awarded'})
            end
          end

          if fellowship.key?('start')
            # Add fellowship start date to events.
            start = fellowship['start']
            events.push({'date' => start, 'text' => 'Fellowship started'})

            if fellowship.key?('end')
              # Add fellowship end date to events.
              ends = fellowship['end']
              events.push({'date' => ends, 'text' => 'Fellowship ended'})

              # Add renewals until end date.
              renew = start >> 12
              today = Date.today()

              while (renew < ends)
                events.push({'date' => renew, 'text' => 'Fellowship renewed'})
                renew = renew >> 12
              end
            else
              # Add renewals until today
              renew = start >> 12
              today = Date.today()

              while (renew < today)
                events.push({'date' => renew, 'text' => 'Fellowship renewed'})
                renew = renew >> 12
              end
            end
          end

          events, labels = set_positions(events)
          post.data['timeline'] = {'labels' => labels, 'events' => events}

          # Add all spend data from site.data.spend.<year> to fellow.spend
          if not post.data.key?('spend')
            post.data['spend'] = {}
          end

          site.data['spend'].each do |year, data|
            data.each do |fellow, spend|
              if spend.size != 0
                if post.data['name'] == fellow
                  post.data['spend'][year.to_i] = spend
                end
              end
            end
          end

          # Sort spend data by year then by category.
          post.data['spend'] = Hash[post.data['spend'].sort_by {|k, v| k}]
          post.data['spend'].each do |year, spend|
            post.data['spend'][year] = Hash[post.data['spend'][year].sort_by {|k, v| k}]
          end

          # Add all contribution data from site.data.contribution.<year> to fellow.contribution
          if not post.data.key?('contribution')
            post.data['contribution'] = {}
          end

          site.data['contribution'].each do |year, data|
            data.each do |fellow, contribution|
              if post.data['fullname'] == fellow
                post.data['contribution'][year.to_i] = contribution
              end
            end
          end

        end
      end
    end
  end
end
