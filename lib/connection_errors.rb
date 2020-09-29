class ConnectionErrors
  class InvalidIdTag < StandardError
    def message
      'Team has no identification tag'
    end
  end
end