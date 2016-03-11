module Backhere
  module Api
    module ExecutionResults

      class ExecutionResult
        attr_accessor :results

        def initialize
          @results = Array.new
        end

        def all_successful?
          result = true
          results.each { |result| result = false unless result.success? }
          result
        end

        def has_error?
          result = false
          results.each { |result| result = true if result.error? }
          result
        end

        def success_messages
          messages = results.map { |result| result.message if result.success?  }.compact
        end

        def error_messages
          messages = results.map { |result| result.message if result.error?  }.compact
        end

        def failure_messages
          messages = results.map { |result| result.message if result.failure?  }.compact  
        end

      end

      class Result
        attr_accessor :type, :message

        def initialize(type, message = '')
          @type = type
          @message = message
        end

        def success?
          type == :success
        end

        def error?
          type == :error
        end

        def failure?
          type == :failure
        end
      end

    end
  end
end