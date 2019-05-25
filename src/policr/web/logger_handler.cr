module Policr::Web
  class LoggerHandler < Kemal::BaseLogHandler
    def initialize(@io : IO = STDOUT)
    end

    def call(context : HTTP::Server::Context)
      elapsed_time = Time.measure { call_next(context) }
      elapsed_text = elapsed_text(elapsed_time)
      @io << Time.now << ' ' << context.response.status_code << ' ' << context.request.method << ' ' << context.request.resource << ' ' << elapsed_text << '\n'
      context
    end

    def write(message : String)
      @io << message
    end

    private def elapsed_text(elapsed)
      millis = elapsed.total_milliseconds
      return "#{millis.round(2)}ms" if millis >= 1

      "#{(millis * 1000).round(2)}µs"
    end
  end
end
