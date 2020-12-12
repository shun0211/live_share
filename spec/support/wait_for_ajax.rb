module WaitForAjax
  # デフォルトのajax通信を待つ時間は2s
  def wait_for_ajax(wait_time = Capybara.default_max_wait_time)
    # ブロックの中身を期限付きで実行する。実行時間を過ぎた場合、Timeout::Errorが発生する。
    Timeout.timeout(wait_time) do
      loop until finished_all_ajax_requests?
    end
    # メソッドにブロックが与えられていれば、trueを返す
    yield if block_given?
  end

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end
end

RSpec.configure do |config|
  # モジュールをIncludeする
  config.include WaitForAjax, type: :system
end
