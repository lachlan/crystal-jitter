require "log"
require "simplog"
require "./mouse"

module Jitter
  VERSION = {{ `shards version "#{__DIR__}"`.chomp.stringify.downcase }}
  Log     = ::Log.for("JITTER")

  # Runs the mouse jitter process
  class Supervisor
    SLEEP_DURATION = 30.0

    # Creates a new supervisor
    def initialize
      backend = SimpLog::FileBackend.new
      backend.retention = 1.day
      ::Log.setup_from_env(backend: backend)
    end

    # Runs supervisor's mouse jitter logic
    def run : Nil
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
end
