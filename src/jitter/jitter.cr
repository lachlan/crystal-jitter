require "log"
require "./mouse"

module Jitter
  SLEEP_DURATION = 30.0
  VERSION        = {{ `shards version "#{__DIR__}"`.chomp.stringify.downcase }}
  Log            = ::Log.for("JITTER")

  # Runs the mouse jitter logic
  def self.run : Nil
    Log.info { "Started" }

    mouse = Mouse.new
    loop do
      begin
        mouse.reposition_if_inert
      rescue ex
        Log.error(exception: ex) { "ERROR during jitter logic" }
      ensure
        duration = Math.min(Random.rand(SLEEP_DURATION) + 1.0, SLEEP_DURATION).seconds
        Log.info { "Sleeping:   #{duration}" }
        sleep(duration)
      end
    end
  ensure
    Log.info { "Stopped" }
  end
end
