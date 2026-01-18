class OmikujiService
  LUCK_WEIGHTS = {
    "大吉" => 5,   # 5%
    "中吉" => 20,
    "小吉" => 30,
    "吉"   => 30,
    "末吉" => 15
  }.freeze

  def draw_omikuji
    chosen_rank = determine_luck
    prompt = genarate_omikuji_prompt(chosen_rank)
    ai_message = GeminiService.new.call(prompt)

    {
      rank: chosen_rank,
      ai_message: ai_message,
    }
  end

  # おみくじの確率を調整
  def determine_luck
    total_weight = LUCK_WEIGHTS.values.sum
    random_point = rand(0..total_weight)

    current_weight = 0
    LUCK_WEIGHTS.each do |luck, percent|
      current_weight += percent
      return luck if random_point <= current_weight
    end
  end

  private

  def genarate_omikuji_prompt(omikuji)
    "これはおみくじ結果です。神社のおみくじの内容に書いてあるような内容を返してください。
     また、以下の条件も踏まえた上でコメントを最低30文字以上、最大100文字以内で返してください。ただし、返す内容は悲観的ではなくポジティブにしてください\n
     ・結果：#{omikuji}に対するコメント。正し、ポジティブにしてください。\n
     ・#{omikuji}の結果を踏まえた、2026年の内容とする
    "
  end
end