rbac:
  create: true
elasticsearch:
  logstash_prefix: ${logstash_prefix}
image:
  repository: ${image_url}
  tag: ${image_tag}
  pullPolicy: Always
configMaps:
  output.conf: |-
    <filter kubernetes.**>
      @type kubernetes_metadata
    </filter>

    <filter **>
      @type record_transformer
      <record>
        aws_account_id ${aws_account_id}
      </record>
    </filter>

    <match **>
      @id elasticsearch
      @type "aws-elasticsearch-service"
      @log_level info
      include_tag_key true
      type_name _doc
      logstash_format true
      logstash_prefix "#{ENV['LOGSTASH_PREFIX']}"
      flush_interval 1s
      reconnect_on_error true

      <endpoint>
        url ${elasticsearch_endpoint}
        region ${region}
      </endpoint>

      <buffer>
        @type file
        path /var/log/fluentd-buffers/kubernetes.system.buffer
        flush_mode interval
        retry_type exponential_backoff
        flush_thread_count 2
        flush_interval 5s
        retry_forever
        retry_max_interval 30
        chunk_limit_size "#{ENV['OUTPUT_BUFFER_CHUNK_LIMIT']}"
        queue_limit_length "#{ENV['OUTPUT_BUFFER_QUEUE_LIMIT']}"
        overflow_action block
      </buffer>
    </match>
