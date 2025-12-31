class OmikujiService
  OMIKUJI_LIST = %w[大吉 中吉 小吉 吉 末吉]
  def draw_omikuji
    chosen_rank = OMIKUJI_LIST.sample
    prompt = genarate_omikuji_prompt(chosen_rank)
    ai_message = GeminiService.new.call(prompt)

    {
      rank: chosen_rank,
      ai_message: ai_message,
    }
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