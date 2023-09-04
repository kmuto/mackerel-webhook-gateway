# Mackerel Webhook Gateway base
# Copyright 2023 Kenshi Muto <kmuto@kmuto.jp>
require 'dotenv'
require 'json'

module MackerelWebhookGateway
  class Base
    def initialize
      Dotenv.load
      @mackerel_url = ENV['MACKEREL_URL'] || 'https://mackerel.io'
      @debug = ENV['DEBUG'] || nil
    end

    def to_date(v)
      Time.at(v.to_i).strftime('%m/%d %H:%M')
    end

    def parse(json)
      begin
        JSON.parse(json, symbolize_names: true)
      rescue JSON::ParserError => e
        if @debug
          puts "[json error]\n#{e}"
        end
        nil
      end
    end

    def sample(h)
      puts "[sample]\n#{h}"
      '{ "event": "sample" }'
    end

    def alert(h)
      puts "[alert]\n#{h}"
      '{ "event": "alert" }'
    end

    def alert_group(h)
      puts "[alert_group]\n#{h}"
      '{ "event": "alertGroup" }'
    end

    def host_register(h)
      puts "[host_register]\n#{h}"
      '{ "event": "hostRegister" }'
    end

    def host_status(h)
      puts "[host_status]\n#{h}"
      '{ "event": "hostStatus" }'
    end

    def host_retire(h)
      puts "[host_retire]\n#{h}"
      '{ "event": "hostRetire" }'
    end

    def monitor_create(h)
      case h[:monitor][:type]
      when 'host'
        monitor_create_host(h)
      when 'external'
        monitor_create_external(h)
      when 'expression'
        monitor_create_expression(h)
      when 'anomalyDetection'
        monitor_create_anomaly_detection(h)
      when 'service'
        monitor_create_service(h)
      when 'connectivity'
        monitor_create_connectivity(h)
      end
    end

    def monitor_create_host(h)
      puts "[monitor_create_host]\n#{h}"
      '{ "event": "monitorCreate/host" }'
    end

    def monitor_create_external(h)
      puts "[monitor_create_external]\n#{h}"
      '{ "event": "monitorCreate/external" }'
    end

    def monitor_create_expression(h)
      puts "[monitor_create_expression]\n#{h}"
      '{ "event": "monitorCreate/expression" }'
    end

    def monitor_create_anomaly_detection(h)
      puts "[monitor_create_anomaly_detection]\n#{h}"
      '{ "event": "monitorCreate/anomalyDetection" }'
    end

    def monitor_create_service(h)
      puts "[monitor_create_service]\n#{h}"
      '{ "event": "monitorCreate/service" }'
    end

    def monitor_create_connectivity(h)
      puts "[monitor_create_connectivity]\n#{h}"
      '{ "event": "monitorCreate/connectivity" }'
    end

    def monitor_update(h)
      case h[:monitor][:type]
      when 'host'
        monitor_update_host(h)
      when 'external'
        monitor_update_external(h)
      when 'expression'
        monitor_update_expression(h)
      when 'anomalyDetection'
        monitor_update_anomaly_detection(h)
      when 'service'
        monitor_update_service(h)
      when 'connectivity'
        monitor_update_connectivity(h)
      end
    end

    def monitor_update_host(h)
      puts "[monitor_update_host]\n#{h}"
      '{ "event": "monitorUpdate/host" }'
    end

    def monitor_update_external(h)
      puts "[monitor_update_external]\n#{h}"
      '{ "event": "monitorUpdate/external" }'
    end

    def monitor_update_expression(h)
      puts "[monitor_update_expression]\n#{h}"
      '{ "event": "monitorUpdate/expression" }'
    end

    def monitor_update_anomaly_detection(h)
      puts "[monitor_update_anomaly_detection]\n#{h}"
      '{ "event": "monitorUpdate/anomalyDetection" }'
    end

    def monitor_update_service(h)
      puts "[monitor_update_service]\n#{h}"
      '{ "event": "monitorUpdate/service" }'
    end

    def monitor_update_connectivity(h)
      puts "[monitor_update_connectivity]\n#{h}"
      '{ "event": "monitorUpdate/connectivity" }'
    end

    def monitor_delete(h)
      case h[:monitor][:type]
      when 'host'
        monitor_delete_host(h)
      when 'external'
        monitor_delete_external(h)
      when 'expression'
        monitor_delete_expression(h)
      when 'anomalyDetection'
        monitor_delete_anomaly_detection(h)
      when 'service'
        monitor_delete_service(h)
      when 'connectivity'
        monitor_delete_connectivity(h)
      end
    end

    def monitor_delete_host(h)
      puts "[monitor_delete_host]\n#{h}"
      '{ "event": "monitorDelete/host" }'
    end

    def monitor_delete_external(h)
      puts "[monitor_delete_external]\n#{h}"
      '{ "event": "monitorDelete/external" }'
    end

    def monitor_delete_expression(h)
      puts "[monitor_delete_expression]\n#{h}"
      '{ "event": "monitorDelete/expression" }'
    end

    def monitor_delete_anomaly_detection(h)
      puts "[monitor_delete_anomaly_detection]\n#{h}"
      '{ "event": "monitorDelete/anomalyDetection" }'
    end

    def monitor_delete_service(h)
      puts "[monitor_delete_service]\n#{h}"
      '{ "event": "monitorDelete/service" }'
    end

    def monitor_delete_connectivity(h)
      puts "[monitor_delete_connectivity]\n#{h}"
      '{ "event": "monitorDelete/connectivity" }'
    end

    def handle_by_event(h)
      case h[:event]
      when 'sample'
        sample(h)
      when 'alert'
        alert(h)
      when 'alertGroup'
        alert_group(h)
      when 'hostRegister'
        host_register(h)
      when 'hostStatus'
        host_status(h)
      when 'hostRetire'
        host_retire(h)
      when 'monitorCreate'
        monitor_create(h)
      when 'monitorUpdate'
        monitor_update(h)
      when 'monitorDelete'
        monitor_delete(h)
      end
    end

    def post(json)
      puts "[post]\n#{json}"
    end

    def run(h)
      h[:mackerel_url] = @mackerel_url
      json = handle_by_event(h)
      post(json) if json
    end
  end
end
