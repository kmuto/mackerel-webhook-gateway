# Mackerel Webhook Gateway

Copyright 2023 Kenshi Muto

MackerelのWebhookを受け取ってほかの形式のWebhookなどに引き渡すゲートウェイ

## 動作パターン
- Sinatraなどでデーモンとして動かす
- LambdaのRubyランタイムで動かす。API GatewayかFunctions URLsで受け取る

いずれかでともかくWebhookレシーバーとして動作するようにした後、MackerelのWebhook通知先に指定する。

## 対応
現時点ではGoogle Chat Webhookを対象に実装中。

`.env`ファイルを用意して以下のようにGoogle ChatスペースのWebhook URLを指定する（Google ChatのWebhookは有償契約版のみの対応であることに注意）。

```
GOOGLECHAT_WEBHOOK=https://chat.googleapis.com/v1/spaces/…
```

## ライセンス
まだ決めてないがOSS。ApacheかMITにしそう
