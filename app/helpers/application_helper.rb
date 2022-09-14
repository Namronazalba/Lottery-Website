module ApplicationHelper
  def banners
    @banners = Banner.where('online_at <= ? AND offline_at > ?', Time.now, Time.now).active
  end
end
