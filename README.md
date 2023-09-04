# Mackerel Webhook Gateway

Copyright 2023 Kenshi Muto

監視サービス[Mackerel](https://ja.mackerel.io)のWebhookを受け取り、ほかの形式のWebhookに引き渡すゲートウェイのライブラリです。

以下のMackerelのWebhook通知に対応します。

- サンプル（「テスト」で送出されるもの）
- アラート通知
- アラートグループ通知
- ホストステータス変更
- ホスト登録
- ホスト退役
- 監視ルールの操作（追加・変更・削除）

## 想定動作パターン
- Sinatraなどでサービスとして動かす
- LambdaのRubyランタイムで動かす。API GatewayかFunctions URLsで受け取る

## Google Chatでの実行
Google Chat Webhookに変換する実装を用意しています。

`.env`ファイルを用意して以下のようにGoogle ChatスペースのWebhook URLを指定します（Google ChatのWebhookは有償プランのみでしか使えません）。

```
GOOGLECHAT_WEBHOOK=https://chat.googleapis.com/v1/spaces/…
```

サービスとして動作するSinatraを用意しています。

```
exe/webhook-handler-googlechat.rb
```

デフォルトでは全IPアドレスにバインドした状態でTCPポート4567、パス`/`で待ち受けます。変更したいときには`.env`ファイルで`SERVER_BIND`・`SERVER_PORT`・`SERVER_PATH`を指定してください。

用意したこのサービスにMackerelから送信するようチャンネルを設定します。

![Google Chatでの通知表示](./googlechat.png)

### カスタマイズ

メッセージを変更したいときには、`lib/mackerel-webhook-gateway/googlechat.rb`を直接書き換える方法もありますが、一部だけであれば`customize.rb`でメソッドをオーバーライドするのが簡単です。

```
# Mackerel Webhook Gateway Override
module GoogleChatOverride
  # MackerelWebhookGateway::GoogleChat の一部のメソッドの挙動(カード出力など)を変えたいときにはここでメソッドを上書きする
  # sampleメソッドを上書きする例
  def sample(h)
    header = { title: '通知のテスト' }
    widget1 = [{ textParagraph: { text: h[:message] } }]
    sections = [{ widgets: widget1 }]
    googlechat_card(header, sections)
  end
end

module MackerelWebhookGateway
  class GoogleChat
    prepend GoogleChatOverride
  end
end
```

## ライセンス
```
MIT License

Copyright (c) 2023 Kenshi Muto

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
