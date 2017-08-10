# frozen_string_literal: true

class Hash
  def convert_hash_keys_to_methods(fixture) # :nodoc:
    Taza::Entity.new(self, fixture)
  end

  # Recursively replace key names that should be symbols with symbols.
  def key_strings_to_symbols!
    result = {}
    each_pair do |key, value|
      value.key_strings_to_symbols! if value.is_a?(Hash) && value.respond_to?(:key_strings_to_symbols!)
      result[key.to_sym] = value
    end
    replace(result)
  end
end
