#!/usr/bin/env ruby
# Mackerel Webhook Gateway
# Support:
#   - Google Chat Webhook
#
# Copyright 2023 Kenshi Muto <kmuto@kmuto.jp>
require 'dotenv'
require 'json'
require 'faraday'
require 'erb'

class MackerelWebhookGateway
  def initialize
    Dotenv.load
    @mackerel_url = ENV['MACKEREL_URL'] || 'https://mackerel.io'
  end

  def parse_mackerel_webhook(json)
    # Return Mackerel's Webhook as Hash
    JSON.parse(json, symbolize_names: true)
  end

  def googlechat_card(header, sections)
    j = { cards: { header: header, sections: sections } }
    JSON.generate(j)
  end
  
  def googlechat_sample(h)
    # Sample
    header = { title: 'Mackerelからのテスト送信' }
    widget1 = [ { textParagraph: { text: h[:message] } } ]
    sections = [{ widgets: widget1 }]
    googlechat_card(header, sections)
  end

  def googlechat_monitorupdate(h)
    # FIXME: ルール更新のパターンがもっとある
    # Monitor updated
    header = { title: %Q([#{h[:orgName]}] 監視ルールが更新されました) }

    target = ''
    case h[:monitor][:type]
    when 'host'
      target = %Q(ホストメトリック (#{h[:monitor][:metric]}))
    when 'service'
      target = %Q(サービスメトリック (#{h[:monitor][:metric]}))
    when 'external'
      target = %Q(外形監視 (<a href="#{h[:monitor][:url]}">#{h[:monitor][:url]}</a>))
    else
      target = %Q(#{h[:monitor][:type]}メトリック)
    end
    
    s = <<EOT.chomp
監視ルール名: <a href="#{h[:mackerel_url]}/orgs/#{h[:orgName]}/monitors/#{h[:monitor][:id]}">#{h[:monitor][:name]}</a>
変更者: #{h[:user][:screenName]}
ターゲット: #{target}
EOT
    widget1 = [ { textParagraph: { text: s } } ]
    sections = [{ widgets: widget1 }]

    if h[:monitor][:memo]
      widget2 = [ { textParagraph: { text: h[:monitor][:memo] } } ]
      sections.push({ widgets: widget2 })
    end

    googlechat_card(header, sections)
  end

  def googlechat_alert(h)
    # FIXME: ヤバいことになっているのでもっと分けたほうがよさそう
    # Alert
    header = { title: %Q([#{h[:orgName]}] #{h[:alert][:status].upcase}: #{h[:alert][:monitorName]}) }
    start_time = Time.at(h[:alert][:openedAt].to_i).strftime('%m/%d %H:%M')
    end_time = h[:alert][:closedAt] ? Time.at(h[:alert][:closedAt].to_i).strftime('%m/%d %H:%M') : nil
    if end_time
      header[:subtitle] = %Q(#{start_time} 〜 #{end_time})
    else
      header[:subtitle] = %Q(#{start_time} 〜)
    end

    sa = []
    if h[:host] && h[:host][:roles]
      sa << %Q(ホスト: <a href="#{h[:host][:url]}">#{h[:host][:name]}</a>)
      h[:host][:roles].each do |a|
        sa << %Q(ロール: [<a href="#{a[:serviceUrl]}">#{a[:serviceName]}</a>] <a href="#{a[:roleUrl]}">#{a[:roleName]}</a>)
      end
    end

    widget1 = [ { textParagraph: { text: sa.join("\n") } } ]
    sections = [{ widgets: widget1 }]

    if h[:imageUrl]
      widget2 = [ { image: {
                      imageUrl: h[:imageUrl],
                      onClick: {
                        openLink: {
                          url: h[:alert][:url]
                        }
                      }
                    } } ]
      sections.push({ widgets: widget2 })
    end

    if h[:memo]
      widget3 = [ { textParagraph: { text: h[:memo] } } ]
      sections.push({ widgets: widget3 })
    end

    googlechat_card(header, sections)
  end
  
  def convert_googlechat(h)
    # FIXME: 登録、退役、アラートグループ、式監視
    erb = nil
    case h[:event]
    when 'sample'
      return googlechat_sample(h)
    when 'monitorUpdate'
      return googlechat_monitorupdate(h)
    when 'alert'
      return googlechat_alert(h)
    end
  end

  def post_googlechat(json)
    resp = Faraday.post ENV['GOOGLECHAT_WEBHOOK'] do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = json
    end
    p resp.body
  end
  
  def gateway_googlechat(h)
    h[:mackerel_url] = @mackerel_url
    json = convert_googlechat(h)
    puts json
    post_googlechat(json) if json
  end
end

m = MackerelWebhookGateway.new
# FIXME: incoming webhook受け付け(lambdaとsinatra両方を実装する必要)
json = <<JSON
{"orgName":"ORG_NAME","event":"alert","alert":{"id":"ALERT_ID","url":"https://mackerel.io/orgs/ORG_NAME/alerts/ALERT_ID","openedAt":1692628521,"closedAt":null,"createdAt":1692628521296,"status":"warning","isOpen":true,"trigger":"monitor","monitorName":" MONITOR_NAME","metricLabel":"custom.linux.users.users","metricValue":1,"criticalThreshold":1,"warningThreshold":0,"monitorOperator":">","duration":1},"memo":"Webサーバーからの5xx応答が増加している。\\nアプリケーションログからエラーの内容を確認してチーム内に共有する。\\n以下の手順書を参照\\n- DRIVE/Webサーバー対応手順F015\\n- DRIVE/Webサーバー対応手順F018<>&'\\"","user":null,"host":{"name":"HOST_NAME","memo":"1","isRetired":false,"id":"HOST_ID","url":"https://mackerel.io/orgs/ORG_NAME/hosts/HOST_ID","status":"working","roles":[{"fullname":"SERVICE_NAME: ROLE_NAME","serviceName":"SERVICE_NAME","roleName":"ROLE_NAME","serviceUrl":"https://mackerel.io/orgs/ORG_NAME/services/SERVICE_NAME","roleUrl":"https://mackerel.io/orgs/ORG_NAME/services/SERVICE_NAME#role=ROLE_NAME"}]},"imageUrl":"https://mackerel.io/embed/public/alert/IMAGE_URL.png"}
JSON
h = m.parse_mackerel_webhook(json)
m.gateway_googlechat(h)
