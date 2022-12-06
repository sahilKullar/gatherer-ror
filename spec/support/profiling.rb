class UnclaimedSlowTestException < RuntimeError
  THRESHOLD = 1

  def initialize(example)
    super
    @example = example
  end

  def message
    "This spec at #{@example.metadata[:location]}
       is slower than #{THRESHOLD} seconds.
       Either make it faster or mark it as :slow in metadata"
  end
end

RSpec.configure do |config|
  config.append_after do |ce|
    runtime = ce.clock.now - ce.metadata[:execution_result].started_at
    if runtime > UnclaimedSlowTestException::THRESHOLD && !ce.metadata[:slow]
      raise UnclaimedSlowTestException, ce
    end
  end
end
