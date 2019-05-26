class LogParser
  def initialize(path)
    @path = path
  end

  def order_logs
    validate_extension
    most_page_views.concat(unique_page_views)
  rescue Errno::ENOENT
    "File #{path} not found"
  rescue TypeError
    'Given file is not a log file'
  end

  private

  attr_reader :path

  def unique_page_views
    logs_to_a
      .uniq
      .then(&method(:count_occurrence))
      .then(&method(:order_by_views))
      .then(&method(:uniqe_page_views_output))
  end

  def most_page_views
    logs_to_a
      .then(&method(:count_occurrence))
      .then(&method(:order_by_views))
      .then(&method(:most_page_views_output))
  end

  def enumerator
    IO.foreach(path)
  end

  def logs_to_a
    @logs_to_a ||= enumerator.each_with_object([]) do |line, object|
      object.push(
        line.chomp.split
      )
    end
  end

  def count_occurrence(logs)
    flatten_logs = logs.flatten
    logs.drop(1).map do |log|
      [
        log.first,
        flatten_logs.count(log.first)
      ]
    end.uniq
  end

  def order_by_views(logs)
    logs.sort_by { |log| log[1] }.reverse!
  end

  def uniqe_page_views_output(logs)
    prepare_output(
      logs,
      header: 'Unique page views:',
      annotation: 'unique views'
    )
  end

  def most_page_views_output(logs)
    prepare_output(
      logs,
      header: 'Most page views:',
      annotation: 'visits'
    )
  end

  def prepare_output(logs, header:, annotation:)
    logs.map do |log|
      log.push(annotation).join(' ')
    end.unshift(header)
  end

  def validate_extension
    return if File.extname(path).eql?('.log')

    raise TypeError
  end
end

puts LogParser.new(ARGV.first).order_logs
