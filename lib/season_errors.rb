class SeasonErrors
  class NoActiveSeasonError < StandardError
    def message
      'Não há nenhuma temporada ativa no momento'
    end
  end
end