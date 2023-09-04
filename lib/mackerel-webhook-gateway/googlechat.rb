# Mackerel Webhook Gateway Google Chat
# Copyright 2023 Kenshi Muto <kmuto@kmuto.jp>
require_relative 'base'
require 'faraday'

module MackerelWebhookGateway
  class GoogleChat < Base
    def googlechat_card(header, sections)
      j = { cards: { header: header, sections: sections } }
      JSON.generate(j)
    end

    def sample(h)
      header = { title: 'notification test' }
      widget1 = [{ textParagraph: { text: h[:message] } }]
      sections = [{ widgets: widget1 }]
      googlechat_card(header, sections)
    end

    def alert(h)
      header = { title: %Q([#{h[:orgName]}] #{h[:alert][:status].upcase}: #{h[:alert][:monitorName]}) }
      start_time = to_date(h[:alert][:openedAt])
      end_time = h[:alert][:closedAt] ? to_date(h[:alert][:closedAt]) : nil
      header[:subtitle] = if end_time
                            %Q(from #{start_time} to #{end_time})
                          else
                            %Q(from #{start_time})
                          end

      sa = []
      sa << %Q(<a href="#{h[:alert][:url]}">View Alert</a>)

      if h[:host] && h[:host][:roles]
        # Host
        sa << %Q(Host: <a href="#{h[:host][:url]}">#{h[:host][:name]}</a>)
        h[:host][:roles].each do |a|
          sa << %Q(Role: [<a href="#{a[:serviceUrl]}">#{a[:serviceName]}</a>] <a href="#{a[:roleUrl]}">#{a[:roleName]}</a>)
        end
      end

      if h[:service] && h[:service][:roles]
        # Service
        sa << %Q(Service: #{h[:service][:name]})
        h[:service][:roles].each do |a|
          sa << %Q(Role: [<a href="#{a[:serviceUrl]}">#{a[:serviceName]}</a>] <a href="#{a[:roleUrl]}">#{a[:roleName]}</a>)
        end
      end

      if h[:alert][:metricLabel]
        # Host, Service, Expression
        if h[:alert][:status] == 'ok'
          sa << %Q(Metric: #{h[:alert][:metricLabel]} #{h[:alert][:metricValue]})
        else
          threshold = if h[:alert][:status] == 'critical'
                        h[:alert][:criticalThreshold]
                      else
                        h[:alert][:warningThreshold]
                      end
          sa << %Q(Metric: #{h[:alert][:metricLabel]} #{h[:alert][:metricValue]} #{h[:alert][:monitorOperator]} #{threshold})
        end
      end

      widget1 = [{ textParagraph: { text: sa.join("\n") } }]
      sections = [{ widgets: widget1 }]

      if h[:imageUrl]
        widget2 = [{
          image: {
            imageUrl: h[:imageUrl],
            onClick: {
              openLink: {
                url: h[:alert][:url]
              }
            }
          }
        }]
        sections.push({ widgets: widget2 })
      end

      if h[:memo]
        widget3 = [{ textParagraph: { text: h[:memo] } }]
        sections.push({ widgets: widget3 })
      end

      googlechat_card(header, sections)
    end

    def alert_group(h)
      header = { title: %Q([#{h[:orgName]}] #{h[:alertGroup][:status].upcase}: #{h[:alertGroupSetting][:name]}) }
      start_time = to_date(h[:alertGroup][:createdAt])  # createdAt
      end_time = h[:alertGroup][:closedAt] ? to_date(h[:alertGroup][:closedAt]) : nil
      header[:subtitle] = if end_time
                            %Q(from #{start_time} to #{end_time})
                          else
                            %Q(from #{start_time})
                          end

      sa = []
      sa << %Q(<a href="#{h[:alertGroup][:url]}">View Alert</a>)

      widget1 = [{ textParagraph: { text: sa.join("\n") } }]
      sections = [{ widgets: widget1 }]

      if h[:alertGroupSetting][:memo]
        widget2 = [{ textParagraph: { text: h[:alertGroupSetting][:memo] } }]
        sections.push({ widgets: widget2 })
      end

      googlechat_card(header, sections)
    end

    def host_register(h)
      header = { title: %Q([#{h[:orgName]}] Host #{h[:host][:name]} is registered) }

      sa = []
      if h[:user]
        sa << %Q(Registered by: #{h[:user][:screenName]})
      end

      if h[:host][:roles]
        sa << %Q(Host: <a href="#{h[:host][:url]}">#{h[:host][:name]}</a>)
        h[:host][:roles].each do |a|
          sa << %Q(Role: [<a href="#{a[:serviceUrl]}">#{a[:serviceName]}</a>] <a href="#{a[:roleUrl]}">#{a[:roleName]}</a>)
        end
      end

      widget1 = [{ textParagraph: { text: sa.join("\n") } }]
      sections = [{ widgets: widget1 }]

      googlechat_card(header, sections)
    end

    def host_status(h)
      header = { title: %Q([#{h[:orgName]}] Host #{h[:host][:name]} is changed to #{h[:host][:status]}) }

      sa = []
      if h[:user]
        sa << %Q(Chagned by: #{h[:user][:screenName]})
      end

      sa << %Q(Previous: #{h[:fromStatus]})
      if h[:host][:roles]
        sa << %Q(Host: <a href="#{h[:host][:url]}">#{h[:host][:name]}</a>)
        h[:host][:roles].each do |a|
          sa << %Q(Role: [<a href="#{a[:serviceUrl]}">#{a[:serviceName]}</a>] <a href="#{a[:roleUrl]}">#{a[:roleName]}</a>)
        end
      end

      widget1 = [{ textParagraph: { text: sa.join("\n") } }]
      sections = [{ widgets: widget1 }]

      googlechat_card(header, sections)
    end

    def host_retire(h)
      header = { title: %Q([#{h[:orgName]}] Host #{h[:host][:name]} is retired) }

      sa = []
      if h[:user]
        sa << %Q(Retired by: #{h[:user][:screenName]})
      end

      if h[:host][:roles]
        sa << %Q(Host: <a href="#{h[:host][:url]}">#{h[:host][:name]}</a>)
        h[:host][:roles].each do |a|
          sa << %Q(Role: [<a href="#{a[:serviceUrl]}">#{a[:serviceName]}</a>] <a href="#{a[:roleUrl]}">#{a[:roleName]}</a>)
        end
      end

      widget1 = [{ textParagraph: { text: sa.join("\n") } }]
      sections = [{ widgets: widget1 }]

      googlechat_card(header, sections)
    end

    def monitor_create_common(h, target)
      header = { title: %Q([#{h[:orgName]}] Monitor #{h[:monitor][:name]} is created) }

      sa = []
      if h[:user]
        sa << %Q(Created by: #{h[:user][:screenName]})
      end

      sa << target

      widget1 = [{ textParagraph: { text: sa.join("\n") } }]
      sections = [{ widgets: widget1 }]

      if h[:monitor][:memo]
        widget2 = [{ textParagraph: { text: h[:monitor][:memo] } }]
        sections.push({ widgets: widget2 })
      end

      googlechat_card(header, sections)
    end

    def monitor_create_host(h)
      monitor_create_common(h, %Q(Target: Host metric (#{h[:monitor][:metric]})))
    end

    def monitor_create_external(h)
      monitor_create_common(h, %Q(Target: External (#{h[:monitor][:url]})))
    end

    def monitor_create_expression(h)
      monitor_create_common(h, %Q(Target: Expression (#{h[:monitor][:expression]})))
    end

    def monitor_create_anomaly_detection(h)
      monitor_create_common(h, %Q(Target: Anormaly detection (#{h[:monitor][:scopes].join(', ')})))
    end

    def monitor_create_service(h)
      monitor_create_common(h, %Q(Target: Service metric (#{h[:monitor][:metric]})))
    end

    def monitor_create_connectivity(h)
      monitor_create_common(h, %Q(Target: Connectivity (#{h[:monitor][:scopes].join(', ')})))
    end

    def monitor_update_common(h, target)
      header = { title: %Q([#{h[:orgName]}] Monitor #{h[:monitor][:name]} is updated) }

      sa = []
      if h[:user]
        sa << %Q(Updated by: #{h[:user][:screenName]})
      end

      sa << target

      widget1 = [{ textParagraph: { text: sa.join("\n") } }]
      sections = [{ widgets: widget1 }]

      if h[:monitor][:memo]
        widget2 = [{ textParagraph: { text: h[:monitor][:memo] } }]
        sections.push({ widgets: widget2 })
      end

      googlechat_card(header, sections)
    end

    def monitor_update_host(h)
      monitor_update_common(h, %Q(Target: Host metric (#{h[:monitor][:metric]})))
    end

    def monitor_update_external(h)
      monitor_update_common(h, %Q(Target: External (#{h[:monitor][:url]})))
    end

    def monitor_update_expression(h)
      monitor_update_common(h, %Q(Target: Expression (#{h[:monitor][:expression]})))
    end

    def monitor_update_anomaly_detection(h)
      monitor_update_common(h, %Q(Target: Anormaly detection (#{h[:monitor][:scopes].join(', ')})))
    end

    def monitor_update_service(h)
      monitor_update_common(h, %Q(Target: Service metric (#{h[:monitor][:metric]})))
    end

    def monitor_update_connectivity(h)
      monitor_update_common(h, %Q(Target: Connectivity (#{h[:monitor][:scopes].join(', ')})))
    end

    def monitor_delete_common(h, target)
      header = { title: %Q([#{h[:orgName]}] Monitor #{h[:monitor][:name]} is deleted) }

      sa = []
      if h[:user]
        sa << %Q(Deleted by: #{h[:user][:screenName]})
      end

      sa << target

      widget1 = [{ textParagraph: { text: sa.join("\n") } }]
      sections = [{ widgets: widget1 }]

      if h[:monitor][:memo]
        widget2 = [{ textParagraph: { text: h[:monitor][:memo] } }]
        sections.push({ widgets: widget2 })
      end

      googlechat_card(header, sections)
    end

    def monitor_delete_host(h)
      monitor_delete_common(h, %Q(Target: Host metric (#{h[:monitor][:metric]})))
    end

    def monitor_delete_external(h)
      monitor_delete_common(h, %Q(Target: External (#{h[:monitor][:url]})))
    end

    def monitor_delete_expression(h)
      monitor_delete_common(h, %Q(Target: Expression (#{h[:monitor][:expression]})))
    end

    def monitor_delete_anomaly_detection(h)
      monitor_delete_common(h, %Q(Target: Anormaly detection (#{h[:monitor][:scopes].join(', ')})))
    end

    def monitor_delete_service(h)
      monitor_delete_common(h, %Q(Target: Service metric (#{h[:monitor][:metric]})))
    end

    def monitor_delete_connectivity(h)
      monitor_delete_common(h, %Q(Target: Connectivity (#{h[:monitor][:scopes].join(', ')})))
    end

    def post(json)
      resp = Faraday.post(ENV['GOOGLECHAT_WEBHOOK']) do |req|
        req.headers['Content-Type'] = 'application/json'
        req.body = json
      end
      if @debug
        p("[post]\n#{resp.body}")
      end
    end
  end
end
