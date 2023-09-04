# Mackerel Webhook Gateway Override
module GoogleChatOverride
  # MackerelWebhookGateway::GoogleChat の一部のメソッドの挙動(カード出力など)を変えたいときにはここでメソッドを上書きする
end

module MackerelWebhookGateway
  class GoogleChat
    prepend GoogleChatOverride
  end
end
