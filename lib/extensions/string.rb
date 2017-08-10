
# frozen_string_literal: true

class String
  # pluralizes a string and turns it into a symbol
  # Example:
  #  "apple".pluralize_to_sym    # => :apples
  def pluralize_to_sym
    pluralize.to_sym
  end

  # takes human readable words and
  # turns it into ruby variable format
  # dash and spaces to underscore
  # and lowercases
  def variablize
    squeeze!(' ')
    gsub!(/\s+/, '_')
    tr!('-', '_')
    squeeze!('_')
    downcase!
    self
  end
end
