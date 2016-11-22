module Commontator
  module ApplicationHelper
    def javascript_proc
      Commontator.javascript_proc.call(self).html_safe
    end

    def date_or_time_ago_in_words(date, separated = "")
      if Time.now - 1.week > date
          date.strftime("%d/%m/%Y #{separated} %H:%M:%S")
      else
        time_ago_in_words(date)
      end
    end
  end
end
