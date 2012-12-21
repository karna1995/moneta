require 'memcached'

module Moneta
  module Adapters
    # Memcached backend (using gem memcached)
    # @api public
    class MemcachedNative < Base
      # Constructor
      #
      # @param [Hash] options
      #
      # Options:
      # * :server - Memcached server (default localhost:11211)
      # * :namespace - Key namespace
      # * Other options passed to Memcached#new
      def initialize(options = {})
        server = options.delete(:server) || 'localhost:11211'
        options.merge!(:prefix_key => options.delete(:namespace)) if options[:namespace]
        @default_ttl = options[:default_ttl] || 604800
        @cache = ::Memcached.new(server, options)
      end

      def load(key, options = {})
        value = @cache.get(key, false)
        if value && options.include?(:expires)
          store(key, value, options)
        else
          value
        end
      rescue ::Memcached::NotFound
      end

      def store(key, value, options = {})
        # TTL must be Fixnum
        @cache.set(key, value, options[:expires] || @default_ttl, false)
        value
      end

      def delete(key, options = {})
        value = @cache.get(key, false)
        @cache.delete(key)
        value
      rescue ::Memcached::NotFound
      end

      def increment(key, amount = 1, options = {})
        result = if amount >= 0
          @cache.increment(key, amount)
        else
          @cache.decrement(key, -amount)
        end
        # HACK: Throw error if applied to invalid value
        if result == 0
          puts 'Warning: Tried to increment non integer value'
          value = @cache.get(key, false) rescue nil
          raise 'Tried to increment non integer value' unless value.to_s == value.to_i.to_s
        end
        result
      rescue ::Memcached::NotFound => ex
        # WARNING: The creation of counters is not multiprocess safe
        # if the counter exists, everything is fine
        puts 'Warning: Counter created in a non thread-safe manner'
        store(key, amount.to_s, options)
        amount
      end

      def clear(options = {})
        @cache.flush
        self
      end
    end
  end
end
