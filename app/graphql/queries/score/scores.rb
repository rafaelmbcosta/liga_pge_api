class Queries::Score::Scores < GraphQL::Schema::Resolver
  description 'Score list'

  argument :dispute_id, Integer, required: true

  def resolve(dispute_id: Integer!)
    array = []
    query = Score.joins(:round)
    query = query.where("rounds.dispute_month_id = ?", dispute_id)
    query = query.group_by { |score| score.team }
    query.each { |k, v| array.push({ team: k, scores: v, score: v.pluck(:final_score).sum })}
    array.sort_by { |element| element[:score] }.reverse
  end
end