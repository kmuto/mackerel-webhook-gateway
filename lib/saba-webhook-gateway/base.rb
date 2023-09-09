# Saba Webhook Gateway base
# Copyright 2023 Kenshi Muto <kmuto@kmuto.jp>
require 'json'

# main namespace for Saba Webhook Gateway
module SabaWebhookGateway
  class Base
    # Initialize a new SabaWebhookGateway object.
    #
    # @return [SabaWebhookGateway::Base]
    def initialize
      @debug = ENV['DEBUG'] || nil
    end

    # Convert epoch to 'MM/DD hh:mm'.
    #
    # @param [Integer] :epoch Time epoch.
    # @return [String]
    def to_date(epoch)
      Time.at(epoch.to_i).strftime('%m/%d %H:%M')
    end

    # Convert JSON to Ruby Hash.
    #
    # @param [String] :json JSON content.
    # @return [Hash]
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

    # Process sample notifications.
    #
    # @param [Hash] :h Event Hash object.
    # @return [String]
    def sample(h)
      puts "[sample]\n#{h}"
      '{ "event": "sample" }'
    end

    # Process alert notifications.
    #
    # @param [Hash] :h Event Hash object.
    # @return [String]
    def alert(h)
      puts "[alert]\n#{h}"
      '{ "event": "alert" }'
    end

    # Process alert group notifications.
    #
    # @param [Hash] :h Event Hash object.
    # @return [String]
    def alert_group(h)
      puts "[alert_group]\n#{h}"
      '{ "event": "alertGroup" }'
    end

    # Process host registration notifications.
    #
    # @param [Hash] :h Event Hash object.
    # @return [String]
    def host_register(h)
      puts "[host_register]\n#{h}"
      '{ "event": "hostRegister" }'
    end

    # Process host status change notifications.
    #
    # @param [Hash] :h Event Hash object.
    # @return [String]
    def host_status(h)
      puts "[host_status]\n#{h}"
      '{ "event": "hostStatus" }'
    end

    # Process host retirement notifications.
    #
    # @param [Hash] :h Event Hash object.
    # @return [String]
    def host_retire(h)
      puts "[host_retire]\n#{h}"
      '{ "event": "hostRetire" }'
    end

    # Process monitor creation notifications.
    #
    # @param [Hash] :h Event Hash object.
    # @return [String]
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

    # Process monitor creation (host) notifications.
    #
    # @param [Hash] :h Event Hash object.
    # @return [String]
    def monitor_create_host(h)
      puts "[monitor_create_host]\n#{h}"
      '{ "event": "monitorCreate/host" }'
    end

    # Process monitor creation (external) notifications.
    #
    # @param [Hash] :h Event Hash object.
    # @return [String]
    def monitor_create_external(h)
      puts "[monitor_create_external]\n#{h}"
      '{ "event": "monitorCreate/external" }'
    end

    # Process monitor creation (expression) notifications.
    #
    # @param [Hash] :h Event Hash object.
    # @return [String]
    def monitor_create_expression(h)
      puts "[monitor_create_expression]\n#{h}"
      '{ "event": "monitorCreate/expression" }'
    end

    # Process monitor creation (anomaly detection) notifications.
    #
    # @param [Hash] :h Event Hash object.
    # @return [String]
    def monitor_create_anomaly_detection(h)
      puts "[monitor_create_anomaly_detection]\n#{h}"
      '{ "event": "monitorCreate/anomalyDetection" }'
    end

    # Process monitor creation (service) notifications.
    #
    # @param [Hash] :h Event Hash object.
    # @return [String]
    def monitor_create_service(h)
      puts "[monitor_create_service]\n#{h}"
      '{ "event": "monitorCreate/service" }'
    end

    # Process monitor creation (connectivity) notifications.
    #
    # @param [Hash] :h Event Hash object.
    # @return [String]
    def monitor_create_connectivity(h)
      puts "[monitor_create_connectivity]\n#{h}"
      '{ "event": "monitorCreate/connectivity" }'
    end

    # Process monitor update notifications.
    #
    # @param [Hash] :h Event Hash object.
    # @return [String]
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

    # Process monitor update (host) notifications.
    #
    # @param [Hash] :h Event Hash object.
    # @return [String]
    def monitor_update_host(h)
      puts "[monitor_update_host]\n#{h}"
      '{ "event": "monitorUpdate/host" }'
    end

    # Process monitor update (external) notifications.
    #
    # @param [Hash] :h Event Hash object.
    # @return [String]
    def monitor_update_external(h)
      puts "[monitor_update_external]\n#{h}"
      '{ "event": "monitorUpdate/external" }'
    end

    # Process monitor update (expression) notifications.
    #
    # @param [Hash] :h Event Hash object.
    # @return [String]
    def monitor_update_expression(h)
      puts "[monitor_update_expression]\n#{h}"
      '{ "event": "monitorUpdate/expression" }'
    end

    # Process monitor update (anomaly detection) notifications.
    #
    # @param [Hash] :h Event Hash object.
    # @return [String]
    def monitor_update_anomaly_detection(h)
      puts "[monitor_update_anomaly_detection]\n#{h}"
      '{ "event": "monitorUpdate/anomalyDetection" }'
    end

    # Process monitor update (service) notifications.
    #
    # @param [Hash] :h Event Hash object.
    # @return [String]
    def monitor_update_service(h)
      puts "[monitor_update_service]\n#{h}"
      '{ "event": "monitorUpdate/service" }'
    end

    # Process monitor update (connectivity) notifications.
    #
    # @param [Hash] :h Event Hash object.
    # @return [String]
    def monitor_update_connectivity(h)
      puts "[monitor_update_connectivity]\n#{h}"
      '{ "event": "monitorUpdate/connectivity" }'
    end

    # Process monitor deletion notifications.
    #
    # @param [Hash] :h Event Hash object.
    # @return [String]
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

    # Process monitor deletion (host) notifications.
    #
    # @param [Hash] :h Event Hash object.
    # @return [String]
    def monitor_delete_host(h)
      puts "[monitor_delete_host]\n#{h}"
      '{ "event": "monitorDelete/host" }'
    end

    # Process monitor deletion (external) notifications.
    #
    # @param [Hash] :h Event Hash object.
    # @return [String]
    def monitor_delete_external(h)
      puts "[monitor_delete_external]\n#{h}"
      '{ "event": "monitorDelete/external" }'
    end

    # Process monitor deletion (expression) notifications.
    #
    # @param [Hash] :h Event Hash object.
    # @return [String]
    def monitor_delete_expression(h)
      puts "[monitor_delete_expression]\n#{h}"
      '{ "event": "monitorDelete/expression" }'
    end

    # Process monitor deletion (anomaly detection) notifications.
    #
    # @param [Hash] :h Event Hash object.
    # @return [String]
    def monitor_delete_anomaly_detection(h)
      puts "[monitor_delete_anomaly_detection]\n#{h}"
      '{ "event": "monitorDelete/anomalyDetection" }'
    end

    # Process monitor deletion (service) notifications.
    #
    # @param [Hash] :h Event Hash object.
    # @return [String]
    def monitor_delete_service(h)
      puts "[monitor_delete_service]\n#{h}"
      '{ "event": "monitorDelete/service" }'
    end

    # Process monitor deletion (connectivity) notifications.
    #
    # @param [Hash] :h Event Hash object.
    # @return [String]
    def monitor_delete_connectivity(h)
      puts "[monitor_delete_connectivity]\n#{h}"
      '{ "event": "monitorDelete/connectivity" }'
    end

    # Call the respective notification method according to the event.
    #
    # @param [Hash] :h Event Hash object.
    # @return [String]
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

    # Post JSON to the target.
    #
    # @param [String] :json JSON content.
    def post(json)
      puts "[post]\n#{json}"
    end

    # Main routine. It receive and process event hash objects and make JSON post calls.
    #
    # @param [Hash] :h Event Hash object.
    def run(h)
      json = handle_by_event(h)
      post(json) if json
    end
  end
end
