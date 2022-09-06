module ItemsHelper
  def progress(item)
    [(item.bets.active_bets(item.batch_count).count.to_f/item.minimum_bet.to_f) * 100, 100].min.to_i
  end
end
