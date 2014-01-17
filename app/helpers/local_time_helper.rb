module LocalTimeHelper
  def local_time(time, options = {})
    time   = utc_time(time)
    format = options.delete(:format).presence
    if format.is_a?(Symbol)
      format = Time::DATE_FORMATS[format] || I18n.t("time.formats.#{format}")
      if !format.is_a?(String) || format =~ /\Atranslation missing/
        format = nil
      end
    end
    format ||= '%B %e, %Y %l:%M%P'

    options[:data] ||= {}
    options[:data].merge! local: :time, format: format

    time_tag time, time.strftime(format), options
  end

  def local_date(time, options = {})
    options.reverse_merge! format: '%B %e, %Y'
    local_time time, options
  end

  def local_time_ago(time, options = {})
    time = utc_time(time)

    options[:data] ||= {}
    options[:data].merge! local: 'time-ago'

    time_tag time, time.strftime('%B %e, %Y %l:%M%P'), options
  end

  def utc_time(time_or_date)
    if time_or_date.respond_to?(:in_time_zone)
      time_or_date.in_time_zone.utc
    else
      time_or_date.to_time.utc
    end
  end
end
