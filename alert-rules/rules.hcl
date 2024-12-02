resource "grafana_rule_group" "rule_group_3a13817853f1bbc3" {
  org_id           = 1
  name             = "config-reloaders"
  folder_uid       = "ae5qdfq4wjhmod"
  interval_seconds = 300

  rule {
    name      = "ConfigReloaderSidecarErrors"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"max_over_time(reloader_last_reload_successful{namespace=~\\\".+\\\"}[5m]) == 0\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "10m"
    annotations = {
      description = "Errors encountered while the {{$labels.pod}} config-reloader sidecar attempts to sync config in {{$labels.namespace}} namespace.\nAs a result, configuration for service running in {{$labels.pod}} may be stale and cannot be updated anymore."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/prometheus-operator/configreloadersidecarerrors"
      summary     = "config-reloader sidecar has not had a successful reload for 10m"
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
}
resource "grafana_rule_group" "rule_group_e77aa3f5cfd16b59" {
  org_id           = 1
  name             = "etcd"
  folder_uid       = "ae5qdfq4wjhmod"
  interval_seconds = 300

  rule {
    name      = "etcdDatabaseHighFragmentationRatio"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"(last_over_time(etcd_mvcc_db_total_size_in_use_in_bytes{job=~\\\".*etcd.*\\\"}[5m])\\n/ last_over_time(etcd_mvcc_db_total_size_in_bytes{job=~\\\".*etcd.*\\\"}[5m])) < 0.5\\nand etcd_mvcc_db_total_size_in_use_in_bytes{job=~\\\".*etcd.*\\\"} > 104857600\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "10m"
    annotations = {
      description = "etcd cluster \"{{ $labels.job }}\": database size in use on instance {{ $labels.instance }} is {{ $values.QUERY_RESULT.Value | humanizePercentage }} of the actual allocated disk space, please run defragmentation (e.g. etcdctl defrag) to retrieve the unused fragmented disk space."
      runbook_url = "https://etcd.io/docs/v3.5/op-guide/maintenance/#defragmentation"
      summary     = "etcd database size in use is less than 50% of the actual allocated storage."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "etcdDatabaseQuotaLowSpace"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"(last_over_time(etcd_mvcc_db_total_size_in_bytes{job=~\\\".*etcd.*\\\"}[5m]) / last_over_time(etcd_server_quota_backend_bytes{job=~\\\".*etcd.*\\\"}[5m]))*100 > 95\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "10m"
    annotations = {
      description = "etcd cluster \"{{ $labels.job }}\": database size exceeds the defined quota on etcd instance {{ $labels.instance }}, please defrag or increase the quota as the writes to etcd will be disabled when it is full."
      summary     = "etcd cluster database is running full."
    }
    labels = {
      severity = "critical"
    }
    is_paused = false
  }
  rule {
    name      = "etcdExcessiveDatabaseGrowth"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"predict_linear(etcd_mvcc_db_total_size_in_bytes{job=~\\\".*etcd.*\\\"}[4h], 4*60*60) > etcd_server_quota_backend_bytes{job=~\\\".*etcd.*\\\"}\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "10m"
    annotations = {
      description = "etcd cluster \"{{ $labels.job }}\": Predicting running out of disk space in the next four hours, based on write observations within the past four hours on etcd instance {{ $labels.instance }}, please check as it might be disruptive."
      summary     = "etcd cluster database growing very fast."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "etcdGRPCRequestsSlow"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"histogram_quantile(0.99, sum(rate(grpc_server_handling_seconds_bucket{job=~\\\".*etcd.*\\\", grpc_method!=\\\"Defragment\\\", grpc_type=\\\"unary\\\"}[5m])) without(grpc_type))\\n> 0.15\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "10m"
    annotations = {
      description = "etcd cluster \"{{ $labels.job }}\": 99th percentile of gRPC requests is {{ $values.QUERY_RESULT.Value }}s on etcd instance {{ $labels.instance }} for {{ $labels.grpc_method }} method."
      summary     = "etcd grpc requests are slow"
    }
    labels = {
      severity = "critical"
    }
    is_paused = false
  }
  rule {
    name      = "etcdHighCommitDurations"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"histogram_quantile(0.99, rate(etcd_disk_backend_commit_duration_seconds_bucket{job=~\\\".*etcd.*\\\"}[5m]))\\n> 0.25\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "10m"
    annotations = {
      description = "etcd cluster \"{{ $labels.job }}\": 99th percentile commit durations {{ $values.QUERY_RESULT.Value }}s on etcd instance {{ $labels.instance }}."
      summary     = "etcd cluster 99th percentile commit durations are too high."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "etcdHighFsyncDurationsCritical"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"histogram_quantile(0.99, rate(etcd_disk_wal_fsync_duration_seconds_bucket{job=~\\\".*etcd.*\\\"}[5m]))\\n> 1\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "10m"
    annotations = {
      description = "etcd cluster \"{{ $labels.job }}\": 99th percentile fsync durations are {{ $values.QUERY_RESULT.Value }}s on etcd instance {{ $labels.instance }}."
      summary     = "etcd cluster 99th percentile fsync durations are too high."
    }
    labels = {
      severity = "critical"
    }
    is_paused = false
  }
  rule {
    name      = "etcdHighFsyncDurationsWarn"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"histogram_quantile(0.99, rate(etcd_disk_wal_fsync_duration_seconds_bucket{job=~\\\".*etcd.*\\\"}[5m]))\\n> 0.5\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "10m"
    annotations = {
      description = "etcd cluster \"{{ $labels.job }}\": 99th percentile fsync durations are {{ $values.QUERY_RESULT.Value }}s on etcd instance {{ $labels.instance }}."
      summary     = "etcd cluster 99th percentile fsync durations are too high."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "etcdHighNumberOfFailedGRPCRequests"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"100 * sum(rate(grpc_server_handled_total{job=~\\\".*etcd.*\\\", grpc_code=~\\\"Unknown|FailedPrecondition|ResourceExhausted|Internal|Unavailable|DataLoss|DeadlineExceeded\\\"}[5m])) without (grpc_type, grpc_code)\\n  /\\nsum(rate(grpc_server_handled_total{job=~\\\".*etcd.*\\\"}[5m])) without (grpc_type, grpc_code)\\n  > 5\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "5m"
    annotations = {
      description = "etcd cluster \"{{ $labels.job }}\": {{ $values.QUERY_RESULT.Value }}% of requests for {{ $labels.grpc_method }} failed on etcd instance {{ $labels.instance }}."
      summary     = "etcd cluster has high number of failed grpc requests."
    }
    labels = {
      severity = "critical"
    }
    is_paused = false
  }
  rule {
    name      = "etcdHighNumberOfFailedGRPCRequestsWarn"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"100 * sum(rate(grpc_server_handled_total{job=~\\\".*etcd.*\\\", grpc_code=~\\\"Unknown|FailedPrecondition|ResourceExhausted|Internal|Unavailable|DataLoss|DeadlineExceeded\\\"}[5m])) without (grpc_type, grpc_code)\\n  /\\nsum(rate(grpc_server_handled_total{job=~\\\".*etcd.*\\\"}[5m])) without (grpc_type, grpc_code)\\n  > 1\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "10m"
    annotations = {
      description = "etcd cluster \"{{ $labels.job }}\": {{ $values.QUERY_RESULT.Value }}% of requests for {{ $labels.grpc_method }} failed on etcd instance {{ $labels.instance }}."
      summary     = "etcd cluster has high number of failed grpc requests."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "etcdHighNumberOfFailedProposals"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"rate(etcd_server_proposals_failed_total{job=~\\\".*etcd.*\\\"}[15m]) > 5\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "etcd cluster \"{{ $labels.job }}\": {{ $values.QUERY_RESULT.Value }} proposal failures within the last 30 minutes on etcd instance {{ $labels.instance }}."
      summary     = "etcd cluster has high number of proposal failures."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "etcdHighNumberOfLeaderChanges"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"increase((max without (instance, pod) (etcd_server_leader_changes_seen_total{job=~\\\".*etcd.*\\\"})\\nor 0*absent(etcd_server_leader_changes_seen_total{job=~\\\".*etcd.*\\\"}))[15m:1m])\\n>= 4\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "5m"
    annotations = {
      description = "etcd cluster \"{{ $labels.job }}\": {{ $values.QUERY_RESULT.Value }} leader changes within the last 15 minutes. Frequent elections may be a sign of insufficient resources, high network latency, or disruptions by other components and should be investigated."
      summary     = "etcd cluster has high number of leader changes."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "etcdInsufficientMembers"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"sum(up{job=~\\\".*etcd.*\\\"} == bool 1) without (instance, pod) < ((count(up{job=~\\\".*etcd.*\\\"}) without (instance, pod) + 1) / 2)\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "3m"
    annotations = {
      description = "etcd cluster \"{{ $labels.job }}\": insufficient members ({{ $values.QUERY_RESULT.Value }})."
      summary     = "etcd cluster has insufficient number of members."
    }
    labels = {
      severity = "critical"
    }
    is_paused = false
  }
  rule {
    name      = "etcdMemberCommunicationSlow"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"histogram_quantile(0.99, rate(etcd_network_peer_round_trip_time_seconds_bucket{job=~\\\".*etcd.*\\\"}[5m]))\\n> 0.15\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "10m"
    annotations = {
      description = "etcd cluster \"{{ $labels.job }}\": member communication with {{ $labels.To }} is taking {{ $values.QUERY_RESULT.Value }}s on etcd instance {{ $labels.instance }}."
      summary     = "etcd cluster member communication is slow."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "etcdMembersDown"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"max without (endpoint) (\\n  sum without (instance, pod) (up{job=~\\\".*etcd.*\\\"} == bool 0)\\nor\\n  count without (To) (\\n    sum without (instance, pod) (rate(etcd_network_peer_sent_failures_total{job=~\\\".*etcd.*\\\"}[120s])) > 0.01\\n  )\\n)\\n> 0\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "10m"
    annotations = {
      description = "etcd cluster \"{{ $labels.job }}\": members are down ({{ $values.QUERY_RESULT.Value }})."
      summary     = "etcd cluster members are down."
    }
    labels = {
      severity = "critical"
    }
    is_paused = false
  }
  rule {
    name      = "etcdNoLeader"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"etcd_server_has_leader{job=~\\\".*etcd.*\\\"} == 0\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "1m"
    annotations = {
      description = "etcd cluster \"{{ $labels.job }}\": member {{ $labels.instance }} has no leader."
      summary     = "etcd cluster has no leader."
    }
    labels = {
      severity = "critical"
    }
    is_paused = false
  }
}
resource "grafana_rule_group" "rule_group_8642175db16246c3" {
  org_id           = 1
  name             = "general-rules"
  folder_uid       = "ae5qdfq4wjhmod"
  interval_seconds = 300

  rule {
    name      = "InfoInhibitor"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"ALERTS{severity = \\\"info\\\"} == 1 unless on (namespace) ALERTS{alertname != \\\"InfoInhibitor\\\", severity =~ \\\"warning|critical\\\", alertstate=\\\"firing\\\"} == 1\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    annotations = {
      description = "This is an alert that is used to inhibit info alerts.\nBy themselves, the info-level alerts are sometimes very noisy, but they are relevant when combined with\nother alerts.\nThis alert fires whenever there's a severity=\"info\" alert, and stops firing when another alert with a\nseverity of 'warning' or 'critical' starts firing on the same namespace.\nThis alert should be routed to a null receiver and configured to inhibit alerts with severity=\"info\".\n"
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/general/infoinhibitor"
      summary     = "Info-level alert inhibition."
    }
    labels = {
      severity = "none"
    }
    is_paused = false
  }
  rule {
    name      = "TargetDown"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"100 * (count(up == 0) BY (cluster, job, namespace, service) / count(up) BY (cluster, job, namespace, service)) > 10\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "10m"
    annotations = {
      description = "{{ printf \"%.4g\" $values.QUERY_RESULT.Value }}% of the {{ $labels.job }}/{{ $labels.service }} targets in {{ $labels.namespace }} namespace are down."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/general/targetdown"
      summary     = "One or more targets are unreachable."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "Watchdog"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"vector(1)\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    annotations = {
      description = "This is an alert meant to ensure that the entire alerting pipeline is functional.\nThis alert is always firing, therefore it should always be firing in Alertmanager\nand always fire against a receiver. There are integrations with various notification\nmechanisms that send a notification when this alert is not firing. For example the\n\"DeadMansSnitch\" integration in PagerDuty.\n"
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/general/watchdog"
      summary     = "An alert that should always be firing to certify that Alertmanager is working properly."
    }
    labels = {
      severity = "none"
    }
    is_paused = false
  }
}
resource "grafana_rule_group" "rule_group_491cf0e2752c6f3c" {
  org_id           = 1
  name             = "kube-apiserver-slos"
  folder_uid       = "ae5qdfq4wjhmod"
  interval_seconds = 300

  rule {
    name      = "KubeAPIErrorBudgetBurn15Min"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"sum by (cluster) (apiserver_request:burnrate6h) > (6.00 * 0.01000)\\nand on (cluster)\\nsum by (cluster) (apiserver_request:burnrate30m) > (6.00 * 0.01000)\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "The API server is burning too much error budget."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeapierrorbudgetburn"
      summary     = "The API server is burning too much error budget."
    }
    labels = {
      long     = "6h"
      severity = "critical"
      short    = "30m"
    }
    is_paused = false
  }
  rule {
    name      = "KubeAPIErrorBudgetBurn1Hour"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"sum by (cluster) (apiserver_request:burnrate1d) > (3.00 * 0.01000)\\nand on (cluster)\\nsum by (cluster) (apiserver_request:burnrate2h) > (3.00 * 0.01000)\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "1h"
    annotations = {
      description = "The API server is burning too much error budget."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeapierrorbudgetburn"
      summary     = "The API server is burning too much error budget."
    }
    labels = {
      long     = "1d"
      severity = "warning"
      short    = "2h"
    }
    is_paused = false
  }
  rule {
    name      = "KubeAPIErrorBudgetBurn2Min"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"sum by (cluster) (apiserver_request:burnrate1h) > (14.40 * 0.01000)\\nand on (cluster)\\nsum by (cluster) (apiserver_request:burnrate5m) > (14.40 * 0.01000)\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "2m"
    annotations = {
      description = "The API server is burning too much error budget."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeapierrorbudgetburn"
      summary     = "The API server is burning too much error budget."
    }
    labels = {
      long     = "1h"
      severity = "critical"
      short    = "5m"
    }
    is_paused = false
  }
  rule {
    name      = "KubeAPIErrorBudgetBurn3Hour"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"sum by (cluster) (apiserver_request:burnrate3d) > (1.00 * 0.01000)\\nand on (cluster)\\nsum by (cluster) (apiserver_request:burnrate6h) > (1.00 * 0.01000)\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "3h"
    annotations = {
      description = "The API server is burning too much error budget."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeapierrorbudgetburn"
      summary     = "The API server is burning too much error budget."
    }
    labels = {
      long     = "3d"
      severity = "warning"
      short    = "6h"
    }
    is_paused = false
  }
}
resource "grafana_rule_group" "rule_group_e1af5db32c42ec58" {
  org_id           = 1
  name             = "kube-state-metrics"
  folder_uid       = "ae5qdfq4wjhmod"
  interval_seconds = 300

  rule {
    name      = "KubeStateMetricsListErrors"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"(sum(rate(kube_state_metrics_list_total{job=\\\"kube-state-metrics\\\",result=\\\"error\\\"}[5m])) by (cluster)\\n  /\\nsum(rate(kube_state_metrics_list_total{job=\\\"kube-state-metrics\\\"}[5m])) by (cluster))\\n> 0.01\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "kube-state-metrics is experiencing errors at an elevated rate in list operations. This is likely causing it to not be able to expose metrics about Kubernetes objects correctly or at all."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kube-state-metrics/kubestatemetricslisterrors"
      summary     = "kube-state-metrics is experiencing errors in list operations."
    }
    labels = {
      severity = "critical"
    }
    is_paused = false
  }
  rule {
    name      = "KubeStateMetricsShardingMismatch"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"stdvar (kube_state_metrics_total_shards{job=\\\"kube-state-metrics\\\"}) by (cluster) != 0\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "kube-state-metrics pods are running with different --total-shards configuration, some Kubernetes objects may be exposed multiple times or not exposed at all."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kube-state-metrics/kubestatemetricsshardingmismatch"
      summary     = "kube-state-metrics sharding is misconfigured."
    }
    labels = {
      severity = "critical"
    }
    is_paused = false
  }
  rule {
    name      = "KubeStateMetricsShardsMissing"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"2^max(kube_state_metrics_total_shards{job=\\\"kube-state-metrics\\\"}) by (cluster) - 1\\n  -\\nsum( 2 ^ max by (cluster, shard_ordinal) (kube_state_metrics_shard_ordinal{job=\\\"kube-state-metrics\\\"}) ) by (cluster)\\n!= 0\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "kube-state-metrics shards are missing, some Kubernetes objects are not being exposed."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kube-state-metrics/kubestatemetricsshardsmissing"
      summary     = "kube-state-metrics shards are missing."
    }
    labels = {
      severity = "critical"
    }
    is_paused = false
  }
  rule {
    name      = "KubeStateMetricsWatchErrors"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"(sum(rate(kube_state_metrics_watch_total{job=\\\"kube-state-metrics\\\",result=\\\"error\\\"}[5m])) by (cluster)\\n  /\\nsum(rate(kube_state_metrics_watch_total{job=\\\"kube-state-metrics\\\"}[5m])) by (cluster))\\n> 0.01\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "kube-state-metrics is experiencing errors at an elevated rate in watch operations. This is likely causing it to not be able to expose metrics about Kubernetes objects correctly or at all."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kube-state-metrics/kubestatemetricswatcherrors"
      summary     = "kube-state-metrics is experiencing errors in watch operations."
    }
    labels = {
      severity = "critical"
    }
    is_paused = false
  }
}
resource "grafana_rule_group" "rule_group_6f9bf38063150914" {
  org_id           = 1
  name             = "kubernetes-apps"
  folder_uid       = "ae5qdfq4wjhmod"
  interval_seconds = 300

  rule {
    name      = "KubeContainerWaiting"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"kube_pod_container_status_waiting_reason{reason!=\\\"CrashLoopBackOff\\\", job=\\\"kube-state-metrics\\\", namespace=~\\\".*\\\"} > 0\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "1h"
    annotations = {
      description = "pod/{{ $labels.pod }} in namespace {{ $labels.namespace }} on container {{ $labels.container}} has been in waiting state for longer than 1 hour. (reason: \"{{ $labels.reason }}\")."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubecontainerwaiting"
      summary     = "Pod container waiting longer than 1 hour"
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "KubeDaemonSetMisScheduled"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"kube_daemonset_status_number_misscheduled{job=\\\"kube-state-metrics\\\", namespace=~\\\".*\\\"} > 0\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "{{ $values.QUERY_RESULT.Value }} Pods of DaemonSet {{ $labels.namespace }}/{{ $labels.daemonset }} are running where they are not supposed to run."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubedaemonsetmisscheduled"
      summary     = "DaemonSet pods are misscheduled."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "KubeDaemonSetNotScheduled"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"kube_daemonset_status_desired_number_scheduled{job=\\\"kube-state-metrics\\\", namespace=~\\\".*\\\"}\\n  -\\nkube_daemonset_status_current_number_scheduled{job=\\\"kube-state-metrics\\\", namespace=~\\\".*\\\"} > 0\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "10m"
    annotations = {
      description = "{{ $values.QUERY_RESULT.Value }} Pods of DaemonSet {{ $labels.namespace }}/{{ $labels.daemonset }} are not scheduled."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubedaemonsetnotscheduled"
      summary     = "DaemonSet pods are not scheduled."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "KubeDaemonSetRolloutStuck"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"(\\n  (\\n    kube_daemonset_status_current_number_scheduled{job=\\\"kube-state-metrics\\\", namespace=~\\\".*\\\"}\\n     !=\\n    kube_daemonset_status_desired_number_scheduled{job=\\\"kube-state-metrics\\\", namespace=~\\\".*\\\"}\\n  ) or (\\n    kube_daemonset_status_number_misscheduled{job=\\\"kube-state-metrics\\\", namespace=~\\\".*\\\"}\\n     !=\\n    0\\n  ) or (\\n    kube_daemonset_status_updated_number_scheduled{job=\\\"kube-state-metrics\\\", namespace=~\\\".*\\\"}\\n     !=\\n    kube_daemonset_status_desired_number_scheduled{job=\\\"kube-state-metrics\\\", namespace=~\\\".*\\\"}\\n  ) or (\\n    kube_daemonset_status_number_available{job=\\\"kube-state-metrics\\\", namespace=~\\\".*\\\"}\\n     !=\\n    kube_daemonset_status_desired_number_scheduled{job=\\\"kube-state-metrics\\\", namespace=~\\\".*\\\"}\\n  )\\n) and (\\n  changes(kube_daemonset_status_updated_number_scheduled{job=\\\"kube-state-metrics\\\", namespace=~\\\".*\\\"}[5m])\\n    ==\\n  0\\n)\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "DaemonSet {{ $labels.namespace }}/{{ $labels.daemonset }} has not finished or progressed for at least 15 minutes."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubedaemonsetrolloutstuck"
      summary     = "DaemonSet rollout is stuck."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "KubeDeploymentGenerationMismatch"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"kube_deployment_status_observed_generation{job=\\\"kube-state-metrics\\\", namespace=~\\\".*\\\"}\\n  !=\\nkube_deployment_metadata_generation{job=\\\"kube-state-metrics\\\", namespace=~\\\".*\\\"}\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "Deployment generation for {{ $labels.namespace }}/{{ $labels.deployment }} does not match, this indicates that the Deployment has failed but has not been rolled back."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubedeploymentgenerationmismatch"
      summary     = "Deployment generation mismatch due to possible roll-back"
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "KubeDeploymentReplicasMismatch"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"(\\n  kube_deployment_spec_replicas{job=\\\"kube-state-metrics\\\", namespace=~\\\".*\\\"}\\n    >\\n  kube_deployment_status_replicas_available{job=\\\"kube-state-metrics\\\", namespace=~\\\".*\\\"}\\n) and (\\n  changes(kube_deployment_status_replicas_updated{job=\\\"kube-state-metrics\\\", namespace=~\\\".*\\\"}[10m])\\n    ==\\n  0\\n)\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "Deployment {{ $labels.namespace }}/{{ $labels.deployment }} has not matched the expected number of replicas for longer than 15 minutes."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubedeploymentreplicasmismatch"
      summary     = "Deployment has not matched the expected number of replicas."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "KubeDeploymentRolloutStuck"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"kube_deployment_status_condition{condition=\\\"Progressing\\\", status=\\\"false\\\",job=\\\"kube-state-metrics\\\", namespace=~\\\".*\\\"}\\n!= 0\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "Rollout of deployment {{ $labels.namespace }}/{{ $labels.deployment }} is not progressing for longer than 15 minutes."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubedeploymentrolloutstuck"
      summary     = "Deployment rollout is not progressing."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "KubeHpaMaxedOut"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"kube_horizontalpodautoscaler_status_current_replicas{job=\\\"kube-state-metrics\\\", namespace=~\\\".*\\\"}\\n  ==\\nkube_horizontalpodautoscaler_spec_max_replicas{job=\\\"kube-state-metrics\\\", namespace=~\\\".*\\\"}\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "HPA {{ $labels.namespace }}/{{ $labels.horizontalpodautoscaler  }} has been running at max replicas for longer than 15 minutes."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubehpamaxedout"
      summary     = "HPA is running at max replicas"
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "KubeHpaReplicasMismatch"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"(kube_horizontalpodautoscaler_status_desired_replicas{job=\\\"kube-state-metrics\\\", namespace=~\\\".*\\\"}\\n  !=\\nkube_horizontalpodautoscaler_status_current_replicas{job=\\\"kube-state-metrics\\\", namespace=~\\\".*\\\"})\\n  and\\n(kube_horizontalpodautoscaler_status_current_replicas{job=\\\"kube-state-metrics\\\", namespace=~\\\".*\\\"}\\n  >\\nkube_horizontalpodautoscaler_spec_min_replicas{job=\\\"kube-state-metrics\\\", namespace=~\\\".*\\\"})\\n  and\\n(kube_horizontalpodautoscaler_status_current_replicas{job=\\\"kube-state-metrics\\\", namespace=~\\\".*\\\"}\\n  <\\nkube_horizontalpodautoscaler_spec_max_replicas{job=\\\"kube-state-metrics\\\", namespace=~\\\".*\\\"})\\n  and\\nchanges(kube_horizontalpodautoscaler_status_current_replicas{job=\\\"kube-state-metrics\\\", namespace=~\\\".*\\\"}[15m]) == 0\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "HPA {{ $labels.namespace }}/{{ $labels.horizontalpodautoscaler  }} has not matched the desired number of replicas for longer than 15 minutes."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubehpareplicasmismatch"
      summary     = "HPA has not matched desired number of replicas."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "KubeJobFailed"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"kube_job_failed{job=\\\"kube-state-metrics\\\", namespace=~\\\".*\\\"}  > 0\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "Job {{ $labels.namespace }}/{{ $labels.job_name }} failed to complete. Removing failed job after investigation should clear this alert."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubejobfailed"
      summary     = "Job failed to complete."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "KubeJobNotCompleted"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"time() - max by (namespace, job_name, cluster) (kube_job_status_start_time{job=\\\"kube-state-metrics\\\", namespace=~\\\".*\\\"}\\n  and\\nkube_job_status_active{job=\\\"kube-state-metrics\\\", namespace=~\\\".*\\\"} > 0) > 43200\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    annotations = {
      description = "Job {{ $labels.namespace }}/{{ $labels.job_name }} is taking more than {{ \"43200\" | humanizeDuration }} to complete."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubejobnotcompleted"
      summary     = "Job did not complete in time"
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "KubePodCrashLooping"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"max_over_time(kube_pod_container_status_waiting_reason{reason=\\\"CrashLoopBackOff\\\",job=\\\"kube-state-metrics\\\", namespace=~\\\".*\\\"}[5m]) >= 1\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "Pod {{ $labels.namespace }}/{{ $labels.pod }} ({{ $labels.container }}) is in waiting state (reason: \"CrashLoopBackOff\")."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubepodcrashlooping"
      summary     = "Pod is crash looping."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "KubePodNotReady"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"sum by (namespace, pod, cluster) (\\n  max by (namespace, pod, cluster) (\\n    kube_pod_status_phase{job=\\\"kube-state-metrics\\\", namespace=~\\\".*\\\", phase=~\\\"Pending|Unknown|Failed\\\"}\\n  ) * on (namespace, pod, cluster) group_left(owner_kind) topk by (namespace, pod, cluster) (\\n    1, max by (namespace, pod, owner_kind, cluster) (kube_pod_owner{owner_kind!=\\\"Job\\\"})\\n  )\\n) > 0\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "Pod {{ $labels.namespace }}/{{ $labels.pod }} has been in a non-ready state for longer than 15 minutes."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubepodnotready"
      summary     = "Pod has been in a non-ready state for more than 15 minutes."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "KubeStatefulSetGenerationMismatch"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"kube_statefulset_status_observed_generation{job=\\\"kube-state-metrics\\\", namespace=~\\\".*\\\"}\\n  !=\\nkube_statefulset_metadata_generation{job=\\\"kube-state-metrics\\\", namespace=~\\\".*\\\"}\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "StatefulSet generation for {{ $labels.namespace }}/{{ $labels.statefulset }} does not match, this indicates that the StatefulSet has failed but has not been rolled back."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubestatefulsetgenerationmismatch"
      summary     = "StatefulSet generation mismatch due to possible roll-back"
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "KubeStatefulSetReplicasMismatch"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"(\\n  kube_statefulset_status_replicas_ready{job=\\\"kube-state-metrics\\\", namespace=~\\\".*\\\"}\\n    !=\\n  kube_statefulset_status_replicas{job=\\\"kube-state-metrics\\\", namespace=~\\\".*\\\"}\\n) and (\\n  changes(kube_statefulset_status_replicas_updated{job=\\\"kube-state-metrics\\\", namespace=~\\\".*\\\"}[10m])\\n    ==\\n  0\\n)\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "StatefulSet {{ $labels.namespace }}/{{ $labels.statefulset }} has not matched the expected number of replicas for longer than 15 minutes."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubestatefulsetreplicasmismatch"
      summary     = "StatefulSet has not matched the expected number of replicas."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "KubeStatefulSetUpdateNotRolledOut"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"(\\n  max by (namespace, statefulset, job, cluster) (\\n    kube_statefulset_status_current_revision{job=\\\"kube-state-metrics\\\", namespace=~\\\".*\\\"}\\n      unless\\n    kube_statefulset_status_update_revision{job=\\\"kube-state-metrics\\\", namespace=~\\\".*\\\"}\\n  )\\n    *\\n  (\\n    kube_statefulset_replicas{job=\\\"kube-state-metrics\\\", namespace=~\\\".*\\\"}\\n      !=\\n    kube_statefulset_status_replicas_updated{job=\\\"kube-state-metrics\\\", namespace=~\\\".*\\\"}\\n  )\\n)  and (\\n  changes(kube_statefulset_status_replicas_updated{job=\\\"kube-state-metrics\\\", namespace=~\\\".*\\\"}[5m])\\n    ==\\n  0\\n)\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "StatefulSet {{ $labels.namespace }}/{{ $labels.statefulset }} update has not been rolled out."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubestatefulsetupdatenotrolledout"
      summary     = "StatefulSet update has not been rolled out."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
}
resource "grafana_rule_group" "rule_group_c9b12239930d55d7" {
  org_id           = 1
  name             = "kubernetes-resources"
  folder_uid       = "ae5qdfq4wjhmod"
  interval_seconds = 300

  rule {
    name      = "CPUThrottlingHigh"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"sum(increase(container_cpu_cfs_throttled_periods_total{container!=\\\"\\\", job=\\\"kubelet\\\", metrics_path=\\\"/metrics/cadvisor\\\", }[5m])) without (id, metrics_path, name, image, endpoint, job, node)\\n  /\\nsum(increase(container_cpu_cfs_periods_total{job=\\\"kubelet\\\", metrics_path=\\\"/metrics/cadvisor\\\", }[5m])) without (id, metrics_path, name, image, endpoint, job, node)\\n  > ( 25 / 100 )\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "{{ $values.QUERY_RESULT.Value | humanizePercentage }} throttling of CPU in namespace {{ $labels.namespace }} for container {{ $labels.container }} in pod {{ $labels.pod }}."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/cputhrottlinghigh"
      summary     = "Processes experience elevated CPU throttling."
    }
    labels = {
      severity = "info"
    }
    is_paused = false
  }
  rule {
    name      = "KubeCPUOvercommit"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"sum(namespace_cpu:kube_pod_container_resource_requests:sum{}) by (cluster) - (sum(kube_node_status_allocatable{job=\\\"kube-state-metrics\\\",resource=\\\"cpu\\\"}) by (cluster) - max(kube_node_status_allocatable{job=\\\"kube-state-metrics\\\",resource=\\\"cpu\\\"}) by (cluster)) > 0\\nand\\n(sum(kube_node_status_allocatable{job=\\\"kube-state-metrics\\\",resource=\\\"cpu\\\"}) by (cluster) - max(kube_node_status_allocatable{job=\\\"kube-state-metrics\\\",resource=\\\"cpu\\\"}) by (cluster)) > 0\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "10m"
    annotations = {
      description = "Cluster {{ $labels.cluster }} has overcommitted CPU resource requests for Pods by {{ $values.QUERY_RESULT.Value }} CPU shares and cannot tolerate node failure."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubecpuovercommit"
      summary     = "Cluster has overcommitted CPU resource requests."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "KubeCPUQuotaOvercommit"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"sum(min without(resource) (kube_resourcequota{job=\\\"kube-state-metrics\\\", type=\\\"hard\\\", resource=~\\\"(cpu|requests.cpu)\\\"})) by (cluster)\\n  /\\nsum(kube_node_status_allocatable{resource=\\\"cpu\\\", job=\\\"kube-state-metrics\\\"}) by (cluster)\\n  > 1.5\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "5m"
    annotations = {
      description = "Cluster {{ $labels.cluster }}  has overcommitted CPU resource requests for Namespaces."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubecpuquotaovercommit"
      summary     = "Cluster has overcommitted CPU resource requests."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "KubeMemoryOvercommit"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"sum(namespace_memory:kube_pod_container_resource_requests:sum{}) by (cluster) - (sum(kube_node_status_allocatable{resource=\\\"memory\\\", job=\\\"kube-state-metrics\\\"}) by (cluster) - max(kube_node_status_allocatable{resource=\\\"memory\\\", job=\\\"kube-state-metrics\\\"}) by (cluster)) > 0\\nand\\n(sum(kube_node_status_allocatable{resource=\\\"memory\\\", job=\\\"kube-state-metrics\\\"}) by (cluster) - max(kube_node_status_allocatable{resource=\\\"memory\\\", job=\\\"kube-state-metrics\\\"}) by (cluster)) > 0\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "10m"
    annotations = {
      description = "Cluster {{ $labels.cluster }} has overcommitted memory resource requests for Pods by {{ $values.QUERY_RESULT.Value | humanize }} bytes and cannot tolerate node failure."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubememoryovercommit"
      summary     = "Cluster has overcommitted memory resource requests."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "KubeMemoryQuotaOvercommit"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"sum(min without(resource) (kube_resourcequota{job=\\\"kube-state-metrics\\\", type=\\\"hard\\\", resource=~\\\"(memory|requests.memory)\\\"})) by (cluster)\\n  /\\nsum(kube_node_status_allocatable{resource=\\\"memory\\\", job=\\\"kube-state-metrics\\\"}) by (cluster)\\n  > 1.5\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "5m"
    annotations = {
      description = "Cluster {{ $labels.cluster }}  has overcommitted memory resource requests for Namespaces."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubememoryquotaovercommit"
      summary     = "Cluster has overcommitted memory resource requests."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "KubeQuotaAlmostFull"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"kube_resourcequota{job=\\\"kube-state-metrics\\\", type=\\\"used\\\"}\\n  / ignoring(instance, job, type)\\n(kube_resourcequota{job=\\\"kube-state-metrics\\\", type=\\\"hard\\\"} > 0)\\n  > 0.9 < 1\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "Namespace {{ $labels.namespace }} is using {{ $values.QUERY_RESULT.Value | humanizePercentage }} of its {{ $labels.resource }} quota."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubequotaalmostfull"
      summary     = "Namespace quota is going to be full."
    }
    labels = {
      severity = "info"
    }
    is_paused = false
  }
  rule {
    name      = "KubeQuotaExceeded"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"kube_resourcequota{job=\\\"kube-state-metrics\\\", type=\\\"used\\\"}\\n  / ignoring(instance, job, type)\\n(kube_resourcequota{job=\\\"kube-state-metrics\\\", type=\\\"hard\\\"} > 0)\\n  > 1\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "Namespace {{ $labels.namespace }} is using {{ $values.QUERY_RESULT.Value | humanizePercentage }} of its {{ $labels.resource }} quota."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubequotaexceeded"
      summary     = "Namespace quota has exceeded the limits."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "KubeQuotaFullyUsed"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"kube_resourcequota{job=\\\"kube-state-metrics\\\", type=\\\"used\\\"}\\n  / ignoring(instance, job, type)\\n(kube_resourcequota{job=\\\"kube-state-metrics\\\", type=\\\"hard\\\"} > 0)\\n  == 1\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "Namespace {{ $labels.namespace }} is using {{ $values.QUERY_RESULT.Value | humanizePercentage }} of its {{ $labels.resource }} quota."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubequotafullyused"
      summary     = "Namespace quota is fully used."
    }
    labels = {
      severity = "info"
    }
    is_paused = false
  }
}
resource "grafana_rule_group" "rule_group_49ec5c2740039af3" {
  org_id           = 1
  name             = "kubernetes-storage"
  folder_uid       = "ae5qdfq4wjhmod"
  interval_seconds = 300

  rule {
    name      = "KubePersistentVolumeErrors"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"kube_persistentvolume_status_phase{phase=~\\\"Failed|Pending\\\",job=\\\"kube-state-metrics\\\"} > 0\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "5m"
    annotations = {
      description = "The persistent volume {{ $labels.persistentvolume }} {{ with $labels.cluster -}} on Cluster {{ . }} {{- end }} has status {{ $labels.phase }}."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubepersistentvolumeerrors"
      summary     = "PersistentVolume is having issues with provisioning."
    }
    labels = {
      severity = "critical"
    }
    is_paused = false
  }
  rule {
    name      = "KubePersistentVolumeFillingUp"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"(\\n  kubelet_volume_stats_available_bytes{job=\\\"kubelet\\\", namespace=~\\\".*\\\", metrics_path=\\\"/metrics\\\"}\\n    /\\n  kubelet_volume_stats_capacity_bytes{job=\\\"kubelet\\\", namespace=~\\\".*\\\", metrics_path=\\\"/metrics\\\"}\\n) < 0.03\\nand\\nkubelet_volume_stats_used_bytes{job=\\\"kubelet\\\", namespace=~\\\".*\\\", metrics_path=\\\"/metrics\\\"} > 0\\nunless on (cluster, namespace, persistentvolumeclaim)\\nkube_persistentvolumeclaim_access_mode{ access_mode=\\\"ReadOnlyMany\\\"} == 1\\nunless on (cluster, namespace, persistentvolumeclaim)\\nkube_persistentvolumeclaim_labels{label_excluded_from_alerts=\\\"true\\\"} == 1\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "1m"
    annotations = {
      description = "The PersistentVolume claimed by {{ $labels.persistentvolumeclaim\n}} in Namespace {{ $labels.namespace }} {{ with $labels.cluster -}} on Cluster\n{{ . }} {{- end }} is only {{ $values.QUERY_RESULT.Value | humanizePercentage }} free."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubepersistentvolumefillingup"
      summary     = "PersistentVolume is filling up."
    }
    labels = {
      severity = "critical"
    }
    is_paused = false
  }
  rule {
    name      = "KubePersistentVolumeFillingUpWithinDays"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"(\\n  kubelet_volume_stats_available_bytes{job=\\\"kubelet\\\", namespace=~\\\".*\\\", metrics_path=\\\"/metrics\\\"}\\n    /\\n  kubelet_volume_stats_capacity_bytes{job=\\\"kubelet\\\", namespace=~\\\".*\\\", metrics_path=\\\"/metrics\\\"}\\n) < 0.15\\nand\\nkubelet_volume_stats_used_bytes{job=\\\"kubelet\\\", namespace=~\\\".*\\\", metrics_path=\\\"/metrics\\\"} > 0\\nand\\npredict_linear(kubelet_volume_stats_available_bytes{job=\\\"kubelet\\\", namespace=~\\\".*\\\", metrics_path=\\\"/metrics\\\"}[6h], 4 * 24 * 3600) < 0\\nunless on (cluster, namespace, persistentvolumeclaim)\\nkube_persistentvolumeclaim_access_mode{ access_mode=\\\"ReadOnlyMany\\\"} == 1\\nunless on (cluster, namespace, persistentvolumeclaim)\\nkube_persistentvolumeclaim_labels{label_excluded_from_alerts=\\\"true\\\"} == 1\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "1h"
    annotations = {
      description = "Based on recent sampling, the PersistentVolume claimed by {{ $labels.persistentvolumeclaim }} in Namespace {{ $labels.namespace }} {{ with $labels.cluster -}} on Cluster {{ . }} {{- end }} is expected to fill up within four days. Currently {{ $values.QUERY_RESULT.Value | humanizePercentage }} is available."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubepersistentvolumefillingup"
      summary     = "PersistentVolume is filling up."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "KubePersistentVolumeInodesFillingUp"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"(\\n  kubelet_volume_stats_inodes_free{job=\\\"kubelet\\\", namespace=~\\\".*\\\", metrics_path=\\\"/metrics\\\"}\\n    /\\n  kubelet_volume_stats_inodes{job=\\\"kubelet\\\", namespace=~\\\".*\\\", metrics_path=\\\"/metrics\\\"}\\n) < 0.03\\nand\\nkubelet_volume_stats_inodes_used{job=\\\"kubelet\\\", namespace=~\\\".*\\\", metrics_path=\\\"/metrics\\\"} > 0\\nunless on (cluster, namespace, persistentvolumeclaim)\\nkube_persistentvolumeclaim_access_mode{ access_mode=\\\"ReadOnlyMany\\\"} == 1\\nunless on (cluster, namespace, persistentvolumeclaim)\\nkube_persistentvolumeclaim_labels{label_excluded_from_alerts=\\\"true\\\"} == 1\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "1m"
    annotations = {
      description = "The PersistentVolume claimed by {{ $labels.persistentvolumeclaim }} in Namespace {{ $labels.namespace }} {{ with $labels.cluster -}} on Cluster {{ . }} {{- end }} only has {{ $values.QUERY_RESULT.Value | humanizePercentage }} free inodes."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubepersistentvolumeinodesfillingup"
      summary     = "PersistentVolumeInodes are filling up."
    }
    labels = {
      severity = "critical"
    }
    is_paused = false
  }
  rule {
    name      = "KubePersistentVolumeInodesFillingUpWithinDays"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"(\\n  kubelet_volume_stats_inodes_free{job=\\\"kubelet\\\", namespace=~\\\".*\\\", metrics_path=\\\"/metrics\\\"}\\n    /\\n  kubelet_volume_stats_inodes{job=\\\"kubelet\\\", namespace=~\\\".*\\\", metrics_path=\\\"/metrics\\\"}\\n) < 0.15\\nand\\nkubelet_volume_stats_inodes_used{job=\\\"kubelet\\\", namespace=~\\\".*\\\", metrics_path=\\\"/metrics\\\"} > 0\\nand\\npredict_linear(kubelet_volume_stats_inodes_free{job=\\\"kubelet\\\", namespace=~\\\".*\\\", metrics_path=\\\"/metrics\\\"}[6h], 4 * 24 * 3600) < 0\\nunless on (cluster, namespace, persistentvolumeclaim)\\nkube_persistentvolumeclaim_access_mode{ access_mode=\\\"ReadOnlyMany\\\"} == 1\\nunless on (cluster, namespace, persistentvolumeclaim)\\nkube_persistentvolumeclaim_labels{label_excluded_from_alerts=\\\"true\\\"} == 1\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "1h"
    annotations = {
      description = "Based on recent sampling, the PersistentVolume claimed by {{ $labels.persistentvolumeclaim }} in Namespace {{ $labels.namespace }} {{ with $labels.cluster -}} on Cluster {{ . }} {{- end }} is expected to run out of inodes within four days. Currently {{ $values.QUERY_RESULT.Value | humanizePercentage }} of its inodes are free."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubepersistentvolumeinodesfillingup"
      summary     = "PersistentVolumeInodes are filling up."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
}
resource "grafana_rule_group" "rule_group_c10af9ffbfa131c7" {
  org_id           = 1
  name             = "kubernetes-system"
  folder_uid       = "ae5qdfq4wjhmod"
  interval_seconds = 300

  rule {
    name      = "KubeClientErrors"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"(sum(rate(rest_client_requests_total{job=\\\"apiserver\\\",code=~\\\"5..\\\"}[5m])) by (cluster, instance, job, namespace)\\n  /\\nsum(rate(rest_client_requests_total{job=\\\"apiserver\\\"}[5m])) by (cluster, instance, job, namespace))\\n> 0.01\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "Kubernetes API server client '{{ $labels.job }}/{{ $labels.instance }}' is experiencing {{ $values.QUERY_RESULT.Value | humanizePercentage }} errors.'"
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeclienterrors"
      summary     = "Kubernetes API server client is experiencing errors."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "KubeVersionMismatch"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"count by (cluster) (count by (git_version, cluster) (label_replace(kubernetes_build_info{job!~\\\"kube-dns|coredns\\\"},\\\"git_version\\\",\\\"$1\\\",\\\"git_version\\\",\\\"(v[0-9]*.[0-9]*).*\\\"))) > 1\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "There are {{ $values.QUERY_RESULT.Value }} different semantic versions of Kubernetes components running."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeversionmismatch"
      summary     = "Different semantic versions of Kubernetes components running."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
}
resource "grafana_rule_group" "rule_group_2c0089d5b8d12a89" {
  org_id           = 1
  name             = "kubernetes-system-apiserver"
  folder_uid       = "ae5qdfq4wjhmod"
  interval_seconds = 300

  rule {
    name      = "KubeAPIDown"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"absent(up{job=\\\"apiserver\\\"} == 1)\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "KubeAPI has disappeared from Prometheus target discovery."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeapidown"
      summary     = "Target disappeared from Prometheus target discovery."
    }
    labels = {
      severity = "critical"
    }
    is_paused = false
  }
  rule {
    name      = "KubeAPITerminatedRequests"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"sum by (cluster) (rate(apiserver_request_terminations_total{job=\\\"apiserver\\\"}[10m]))\\n/ ( sum by (cluster) (rate(apiserver_request_total{job=\\\"apiserver\\\"}[10m])) +\\nsum by (cluster) (rate(apiserver_request_terminations_total{job=\\\"apiserver\\\"}[10m]))\\n) > 0.20\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "5m"
    annotations = {
      description = "The kubernetes apiserver has terminated {{ $values.QUERY_RESULT.Value | humanizePercentage }} of its incoming requests."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeapiterminatedrequests"
      summary     = "The kubernetes apiserver has terminated {{ $values.QUERY_RESULT.Value | humanizePercentage }} of its incoming requests."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "KubeAggregatedAPIDown"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"(1 - max by (name, namespace, cluster)(avg_over_time(aggregator_unavailable_apiservice{job=\\\"apiserver\\\"}[10m]))) * 100 < 85\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "5m"
    annotations = {
      description = "Kubernetes aggregated API {{ $labels.name }}/{{ $labels.namespace }} has been only {{ $values.QUERY_RESULT.Value | humanize }}% available over the last 10m."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeaggregatedapidown"
      summary     = "Kubernetes aggregated API is down."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "KubeAggregatedAPIErrors"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"sum by (name, namespace, cluster)(increase(aggregator_unavailable_apiservice_total{job=\\\"apiserver\\\"}[10m])) > 4\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    annotations = {
      description = "Kubernetes aggregated API {{ $labels.name }}/{{ $labels.namespace }} has reported errors. It has appeared unavailable {{ $values.QUERY_RESULT.Value | humanize }} times averaged over the past 10m."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeaggregatedapierrors"
      summary     = "Kubernetes aggregated API has reported errors."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "KubeClientCertificateExpirationIn24Hours"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"histogram_quantile(0.01, sum without (namespace, service, endpoint) (rate(apiserver_client_certificate_expiration_seconds_bucket{job=\\\"apiserver\\\"}[5m]))) < 86400\\nand\\non (job, cluster, instance) apiserver_client_certificate_expiration_seconds_count{job=\\\"apiserver\\\"} > 0\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "5m"
    annotations = {
      description = "A client certificate used to authenticate to kubernetes apiserver is expiring in less than 24.0 hours."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeclientcertificateexpiration"
      summary     = "Client certificate is about to expire."
    }
    labels = {
      severity = "critical"
    }
    is_paused = false
  }
  rule {
    name      = "KubeClientCertificateExpirationInWeek"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"histogram_quantile(0.01, sum without (namespace, service, endpoint) (rate(apiserver_client_certificate_expiration_seconds_bucket{job=\\\"apiserver\\\"}[5m]))) < 604800\\nand\\non (job, cluster, instance) apiserver_client_certificate_expiration_seconds_count{job=\\\"apiserver\\\"} > 0\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "5m"
    annotations = {
      description = "A client certificate used to authenticate to kubernetes apiserver is expiring in less than 7.0 days."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeclientcertificateexpiration"
      summary     = "Client certificate is about to expire."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
}
resource "grafana_rule_group" "rule_group_db65c0eadcb2fa6e" {
  org_id           = 1
  name             = "kubernetes-system-controller-manager"
  folder_uid       = "ae5qdfq4wjhmod"
  interval_seconds = 300

  rule {
    name      = "KubeControllerManagerDown"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"absent(up{job=\\\"kube-controller-manager\\\"} == 1)\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "KubeControllerManager has disappeared from Prometheus target discovery."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubecontrollermanagerdown"
      summary     = "Target disappeared from Prometheus target discovery."
    }
    labels = {
      severity = "critical"
    }
    is_paused = false
  }
}
resource "grafana_rule_group" "rule_group_3f1b2f7b1fc87b38" {
  org_id           = 1
  name             = "kubernetes-system-kube-proxy"
  folder_uid       = "ae5qdfq4wjhmod"
  interval_seconds = 300

  rule {
    name      = "KubeProxyDown"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"absent(up{job=\\\"kube-proxy\\\"} == 1)\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "KubeProxy has disappeared from Prometheus target discovery."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeproxydown"
      summary     = "Target disappeared from Prometheus target discovery."
    }
    labels = {
      severity = "critical"
    }
    is_paused = false
  }
}
resource "grafana_rule_group" "rule_group_f61b2d5f53f5429a" {
  org_id           = 1
  name             = "kubernetes-system-kubelet"
  folder_uid       = "ae5qdfq4wjhmod"
  interval_seconds = 300

  rule {
    name      = "KubeNodeNotReady"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"kube_node_status_condition{job=\\\"kube-state-metrics\\\",condition=\\\"Ready\\\",status=\\\"true\\\"} == 0\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "{{ $labels.node }} has been unready for more than 15 minutes."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubenodenotready"
      summary     = "Node is not ready."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "KubeNodeReadinessFlapping"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"sum(changes(kube_node_status_condition{job=\\\"kube-state-metrics\\\",status=\\\"true\\\",condition=\\\"Ready\\\"}[15m])) by (cluster, node) > 2\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "The readiness status of node {{ $labels.node }} has changed {{ $values.QUERY_RESULT.Value }} times in the last 15 minutes."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubenodereadinessflapping"
      summary     = "Node readiness status is flapping."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "KubeNodeUnreachable"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"(kube_node_spec_taint{job=\\\"kube-state-metrics\\\",key=\\\"node.kubernetes.io/unreachable\\\",effect=\\\"NoSchedule\\\"}\\nunless ignoring(key,value) kube_node_spec_taint{job=\\\"kube-state-metrics\\\",key=~\\\"ToBeDeletedByClusterAutoscaler|cloud.google.com/impending-node-termination|aws-node-termination-handler/spot-itn\\\"})\\n== 1\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "{{ $labels.node }} is unreachable and some workloads may be rescheduled."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubenodeunreachable"
      summary     = "Node is unreachable."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "KubeletClientCertificateExpirationTommorow"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"kubelet_certificate_manager_client_ttl_seconds < 86400\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    annotations = {
      description = "Client certificate for Kubelet on node {{ $labels.node }} expires in {{ $values.QUERY_RESULT.Value | humanizeDuration }}."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeletclientcertificateexpiration"
      summary     = "Kubelet client certificate is about to expire."
    }
    labels = {
      severity = "critical"
    }
    is_paused = false
  }
  rule {
    name      = "KubeletClientCertificateExpirationWithinWeek"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"kubelet_certificate_manager_client_ttl_seconds < 604800\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    annotations = {
      description = "Client certificate for Kubelet on node {{ $labels.node }} expires in {{ $values.QUERY_RESULT.Value | humanizeDuration }}."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeletclientcertificateexpiration"
      summary     = "Kubelet client certificate is about to expire."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "KubeletClientCertificateRenewalErrors"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"increase(kubelet_certificate_manager_client_expiration_renew_errors[5m]) > 0\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "Kubelet on node {{ $labels.node }} has failed to renew its client certificate ({{ $values.QUERY_RESULT.Value | humanize }} errors in the last 5 minutes)."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeletclientcertificaterenewalerrors"
      summary     = "Kubelet has failed to renew its client certificate."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "KubeletDown"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"absent(up{job=\\\"kubelet\\\", metrics_path=\\\"/metrics\\\"} == 1)\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "Kubelet has disappeared from Prometheus target discovery."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeletdown"
      summary     = "Target disappeared from Prometheus target discovery."
    }
    labels = {
      severity = "critical"
    }
    is_paused = false
  }
  rule {
    name      = "KubeletPlegDurationHigh"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"node_quantile:kubelet_pleg_relist_duration_seconds:histogram_quantile{quantile=\\\"0.99\\\"} >= 10\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "5m"
    annotations = {
      description = "The Kubelet Pod Lifecycle Event Generator has a 99th percentile duration of {{ $values.QUERY_RESULT.Value }} seconds on node {{ $labels.node }}."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeletplegdurationhigh"
      summary     = "Kubelet Pod Lifecycle Event Generator is taking too long to relist."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "KubeletPodStartUpLatencyHigh"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"histogram_quantile(0.99, sum(rate(kubelet_pod_worker_duration_seconds_bucket{job=\\\"kubelet\\\",\\nmetrics_path=\\\"/metrics\\\"}[5m])) by (cluster, instance, le)) * on (cluster, instance)\\ngroup_left(node) kubelet_node_name{job=\\\"kubelet\\\", metrics_path=\\\"/metrics\\\"} >\\n60\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "Kubelet Pod startup 99th percentile latency is {{ $values.QUERY_RESULT.Value }} seconds on node {{ $labels.node }}."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeletpodstartuplatencyhigh"
      summary     = "Kubelet Pod startup latency is too high."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "KubeletServerCertificateExpirationTommorow"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"kubelet_certificate_manager_server_ttl_seconds < 86400\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    annotations = {
      description = "Server certificate for Kubelet on node {{ $labels.node }} expires in {{ $values.QUERY_RESULT.Value | humanizeDuration }}."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeletservercertificateexpiration"
      summary     = "Kubelet server certificate is about to expire."
    }
    labels = {
      severity = "critical"
    }
    is_paused = false
  }
  rule {
    name      = "KubeletServerCertificateExpirationWithinWeek"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"kubelet_certificate_manager_server_ttl_seconds < 604800\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    annotations = {
      description = "Server certificate for Kubelet on node {{ $labels.node }} expires in {{ $values.QUERY_RESULT.Value | humanizeDuration }}."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeletservercertificateexpiration"
      summary     = "Kubelet server certificate is about to expire."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "KubeletServerCertificateRenewalErrors"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"increase(kubelet_server_expiration_renew_errors[5m]) > 0\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "Kubelet on node {{ $labels.node }} has failed to renew its server certificate ({{ $values.QUERY_RESULT.Value | humanize }} errors in the last 5 minutes)."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeletservercertificaterenewalerrors"
      summary     = "Kubelet has failed to renew its server certificate."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "KubeletTooManyPods"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"count by (cluster, node) (\\n  (kube_pod_status_phase{job=\\\"kube-state-metrics\\\",phase=\\\"Running\\\"} == 1) * on (instance,pod,namespace,cluster) group_left(node) topk by (instance,pod,namespace,cluster) (1, kube_pod_info{job=\\\"kube-state-metrics\\\"})\\n)\\n/\\nmax by (cluster, node) (\\n  kube_node_status_capacity{job=\\\"kube-state-metrics\\\",resource=\\\"pods\\\"} != 1\\n) > 0.95\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "Kubelet '{{ $labels.node }}' is running at {{ $values.QUERY_RESULT.Value | humanizePercentage }} of its Pod capacity."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubelettoomanypods"
      summary     = "Kubelet is running at capacity."
    }
    labels = {
      severity = "info"
    }
    is_paused = false
  }
}
resource "grafana_rule_group" "rule_group_6b943a247e8a066b" {
  org_id           = 1
  name             = "kubernetes-system-scheduler"
  folder_uid       = "ae5qdfq4wjhmod"
  interval_seconds = 300

  rule {
    name      = "KubeSchedulerDown"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"absent(up{job=\\\"kube-scheduler\\\"} == 1)\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "KubeScheduler has disappeared from Prometheus target discovery."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/kubernetes/kubeschedulerdown"
      summary     = "Target disappeared from Prometheus target discovery."
    }
    labels = {
      severity = "critical"
    }
    is_paused = false
  }
}
resource "grafana_rule_group" "rule_group_b2e41c0806b2514f" {
  org_id           = 1
  name             = "node-exporter"
  folder_uid       = "ae5qdfq4wjhmod"
  interval_seconds = 300

  rule {
    name      = "NodeBondingDegraded"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"(node_bonding_slaves - node_bonding_active) != 0\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "5m"
    annotations = {
      description = "Bonding interface {{ $labels.master }} on {{ $labels.instance }} is in degraded state due to one or more slave failures."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/node/nodebondingdegraded"
      summary     = "Bonding interface is degraded"
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "NodeCPUHighUsage"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"sum without(mode) (avg without (cpu) (rate(node_cpu_seconds_total{job=\\\"node-exporter\\\", mode!=\\\"idle\\\"}[2m]))) * 100 > 90\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "CPU usage at {{ $labels.instance }} has been above 90% for the last 15 minutes, is currently at {{ printf \"%.2f\" $values.QUERY_RESULT.Value }}%.\n"
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/node/nodecpuhighusage"
      summary     = "High CPU usage."
    }
    labels = {
      severity = "info"
    }
    is_paused = false
  }
  rule {
    name      = "NodeClockNotSynchronising"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"min_over_time(node_timex_sync_status{job=\\\"node-exporter\\\"}[5m]) == 0\\nand\\nnode_timex_maxerror_seconds{job=\\\"node-exporter\\\"} >= 16\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "10m"
    annotations = {
      description = "Clock at {{ $labels.instance }} is not synchronising. Ensure NTP is configured on this host."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/node/nodeclocknotsynchronising"
      summary     = "Clock not synchronising."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "NodeClockSkewDetected"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"(\\n  node_timex_offset_seconds{job=\\\"node-exporter\\\"} > 0.05\\nand\\n  deriv(node_timex_offset_seconds{job=\\\"node-exporter\\\"}[5m]) >= 0\\n)\\nor\\n(\\n  node_timex_offset_seconds{job=\\\"node-exporter\\\"} < -0.05\\nand\\n  deriv(node_timex_offset_seconds{job=\\\"node-exporter\\\"}[5m]) <= 0\\n)\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "10m"
    annotations = {
      description = "Clock at {{ $labels.instance }} is out of sync by more than 0.05s. Ensure NTP is configured correctly on this host."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/node/nodeclockskewdetected"
      summary     = "Clock skew detected."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "NodeDiskIOSaturation"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"rate(node_disk_io_time_weighted_seconds_total{job=\\\"node-exporter\\\", device=~\\\"(/dev/)?(mmcblk.p.+|nvme.+|rbd.+|sd.+|vd.+|xvd.+|dm-.+|md.+|dasd.+)\\\"}[5m]) > 10\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "30m"
    annotations = {
      description = "Disk IO queue (aqu-sq) is high on {{ $labels.device }} at {{ $labels.instance }}, has been above 10 for the last 30 minutes, is currently at {{ printf \"%.2f\" $values.QUERY_RESULT.Value }}.\nThis symptom might indicate disk saturation.\n"
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/node/nodediskiosaturation"
      summary     = "Disk IO queue is high."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "NodeFileDescriptorLimit"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"(\\n  node_filefd_allocated{job=\\\"node-exporter\\\"} * 100 / node_filefd_maximum{job=\\\"node-exporter\\\"} > 90\\n)\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "File descriptors limit at {{ $labels.instance }} is currently at {{ printf \"%.2f\" $values.QUERY_RESULT.Value }}%."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/node/nodefiledescriptorlimit"
      summary     = "Kernel is predicted to exhaust file descriptors limit soon."
    }
    labels = {
      severity = "critical"
    }
    is_paused = false
  }
  rule {
    name      = "NodeFileDescriptorLimitWarn"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"(\\n  node_filefd_allocated{job=\\\"node-exporter\\\"} * 100 / node_filefd_maximum{job=\\\"node-exporter\\\"} > 70\\n)\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "File descriptors limit at {{ $labels.instance }} is currently at {{ printf \"%.2f\" $values.QUERY_RESULT.Value }}%."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/node/nodefiledescriptorlimit"
      summary     = "Kernel is predicted to exhaust file descriptors limit soon."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "NodeFilesystemAlmostOutOfFilesFivePercent"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"(\\n  node_filesystem_files_free{job=\\\"node-exporter\\\",fstype!=\\\"\\\",mountpoint!=\\\"\\\"} / node_filesystem_files{job=\\\"node-exporter\\\",fstype!=\\\"\\\",mountpoint!=\\\"\\\"} * 100 < 5\\nand\\n  node_filesystem_readonly{job=\\\"node-exporter\\\",fstype!=\\\"\\\",mountpoint!=\\\"\\\"} == 0\\n)\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "1h"
    annotations = {
      description = "Filesystem on {{ $labels.device }}, mounted on {{ $labels.mountpoint }}, at {{ $labels.instance }} has only {{ printf \"%.2f\" $values.QUERY_RESULT.Value }}% available inodes left."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/node/nodefilesystemalmostoutoffiles"
      summary     = "Filesystem has less than 5% inodes left."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "NodeFilesystemAlmostOutOfFilesThreePercent"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"(\\n  node_filesystem_files_free{job=\\\"node-exporter\\\",fstype!=\\\"\\\",mountpoint!=\\\"\\\"} / node_filesystem_files{job=\\\"node-exporter\\\",fstype!=\\\"\\\",mountpoint!=\\\"\\\"} * 100 < 3\\nand\\n  node_filesystem_readonly{job=\\\"node-exporter\\\",fstype!=\\\"\\\",mountpoint!=\\\"\\\"} == 0\\n)\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "1h"
    annotations = {
      description = "Filesystem on {{ $labels.device }}, mounted on {{ $labels.mountpoint }}, at {{ $labels.instance }} has only {{ printf \"%.2f\" $values.QUERY_RESULT.Value }}% available inodes left."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/node/nodefilesystemalmostoutoffiles"
      summary     = "Filesystem has less than 3% inodes left."
    }
    labels = {
      severity = "critical"
    }
    is_paused = false
  }
  rule {
    name      = "NodeFilesystemAlmostOutOfSpaceFivePercent"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"(\\n  node_filesystem_avail_bytes{job=\\\"node-exporter\\\",fstype!=\\\"\\\",mountpoint!=\\\"\\\"} / node_filesystem_size_bytes{job=\\\"node-exporter\\\",fstype!=\\\"\\\",mountpoint!=\\\"\\\"} * 100 < 5\\nand\\n  node_filesystem_readonly{job=\\\"node-exporter\\\",fstype!=\\\"\\\",mountpoint!=\\\"\\\"} == 0\\n)\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "30m"
    annotations = {
      description = "Filesystem on {{ $labels.device }}, mounted on {{ $labels.mountpoint }}, at {{ $labels.instance }} has only {{ printf \"%.2f\" $values.QUERY_RESULT.Value }}% available space left."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/node/nodefilesystemalmostoutofspace"
      summary     = "Filesystem has less than 5% space left."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "NodeFilesystemAlmostOutOfSpaceThreePercent"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"(\\n  node_filesystem_avail_bytes{job=\\\"node-exporter\\\",fstype!=\\\"\\\",mountpoint!=\\\"\\\"} / node_filesystem_size_bytes{job=\\\"node-exporter\\\",fstype!=\\\"\\\",mountpoint!=\\\"\\\"} * 100 < 3\\nand\\n  node_filesystem_readonly{job=\\\"node-exporter\\\",fstype!=\\\"\\\",mountpoint!=\\\"\\\"} == 0\\n)\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "30m"
    annotations = {
      description = "Filesystem on {{ $labels.device }}, mounted on {{ $labels.mountpoint }}, at {{ $labels.instance }} has only {{ printf \"%.2f\" $values.QUERY_RESULT.Value }}% available space left."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/node/nodefilesystemalmostoutofspace"
      summary     = "Filesystem has less than 3% space left."
    }
    labels = {
      severity = "critical"
    }
    is_paused = false
  }
  rule {
    name      = "NodeFilesystemFilesFillingUp"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"(\\n  node_filesystem_files_free{job=\\\"node-exporter\\\",fstype!=\\\"\\\",mountpoint!=\\\"\\\"} / node_filesystem_files{job=\\\"node-exporter\\\",fstype!=\\\"\\\",mountpoint!=\\\"\\\"} * 100 < 40\\nand\\n  predict_linear(node_filesystem_files_free{job=\\\"node-exporter\\\",fstype!=\\\"\\\",mountpoint!=\\\"\\\"}[6h], 24*60*60) < 0\\nand\\n  node_filesystem_readonly{job=\\\"node-exporter\\\",fstype!=\\\"\\\",mountpoint!=\\\"\\\"} == 0\\n)\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "1h"
    annotations = {
      description = "Filesystem on {{ $labels.device }}, mounted on {{ $labels.mountpoint }}, at {{ $labels.instance }} has only {{ printf \"%.2f\" $values.QUERY_RESULT.Value }}% available inodes left and is filling up."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/node/nodefilesystemfilesfillingup"
      summary     = "Filesystem is predicted to run out of inodes within the next 24 hours."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "NodeFilesystemFilesFillingUpFast"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"(\\n  node_filesystem_files_free{job=\\\"node-exporter\\\",fstype!=\\\"\\\",mountpoint!=\\\"\\\"} / node_filesystem_files{job=\\\"node-exporter\\\",fstype!=\\\"\\\",mountpoint!=\\\"\\\"} * 100 < 20\\nand\\n  predict_linear(node_filesystem_files_free{job=\\\"node-exporter\\\",fstype!=\\\"\\\",mountpoint!=\\\"\\\"}[6h], 4*60*60) < 0\\nand\\n  node_filesystem_readonly{job=\\\"node-exporter\\\",fstype!=\\\"\\\",mountpoint!=\\\"\\\"} == 0\\n)\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "1h"
    annotations = {
      description = "Filesystem on {{ $labels.device }}, mounted on {{ $labels.mountpoint }}, at {{ $labels.instance }} has only {{ printf \"%.2f\" $values.QUERY_RESULT.Value }}% available inodes left and is filling up fast."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/node/nodefilesystemfilesfillingup"
      summary     = "Filesystem is predicted to run out of inodes within the next 4 hours."
    }
    labels = {
      severity = "critical"
    }
    is_paused = false
  }
  rule {
    name      = "NodeFilesystemSpaceFillingUp"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"(\\n  node_filesystem_avail_bytes{job=\\\"node-exporter\\\",fstype!=\\\"\\\",mountpoint!=\\\"\\\"} / node_filesystem_size_bytes{job=\\\"node-exporter\\\",fstype!=\\\"\\\",mountpoint!=\\\"\\\"} * 100 < 15\\nand\\n  predict_linear(node_filesystem_avail_bytes{job=\\\"node-exporter\\\",fstype!=\\\"\\\",mountpoint!=\\\"\\\"}[6h], 24*60*60) < 0\\nand\\n  node_filesystem_readonly{job=\\\"node-exporter\\\",fstype!=\\\"\\\",mountpoint!=\\\"\\\"} == 0\\n)\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "1h"
    annotations = {
      description = "Filesystem on {{ $labels.device }}, mounted on {{ $labels.mountpoint }}, at {{ $labels.instance }} has only {{ printf \"%.2f\" $values.QUERY_RESULT.Value }}% available space left and is filling up."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/node/nodefilesystemspacefillingup"
      summary     = "Filesystem is predicted to run out of space within the next 24 hours."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "NodeFilesystemSpaceFillingUpFast"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"(\\n  node_filesystem_avail_bytes{job=\\\"node-exporter\\\",fstype!=\\\"\\\",mountpoint!=\\\"\\\"} / node_filesystem_size_bytes{job=\\\"node-exporter\\\",fstype!=\\\"\\\",mountpoint!=\\\"\\\"} * 100 < 10\\nand\\n  predict_linear(node_filesystem_avail_bytes{job=\\\"node-exporter\\\",fstype!=\\\"\\\",mountpoint!=\\\"\\\"}[6h], 4*60*60) < 0\\nand\\n  node_filesystem_readonly{job=\\\"node-exporter\\\",fstype!=\\\"\\\",mountpoint!=\\\"\\\"} == 0\\n)\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "1h"
    annotations = {
      description = "Filesystem on {{ $labels.device }}, mounted on {{ $labels.mountpoint }}, at {{ $labels.instance }} has only {{ printf \"%.2f\" $values.QUERY_RESULT.Value }}% available space left and is filling up fast."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/node/nodefilesystemspacefillingup"
      summary     = "Filesystem is predicted to run out of space within the next 4 hours."
    }
    labels = {
      severity = "critical"
    }
    is_paused = false
  }
  rule {
    name      = "NodeHighNumberConntrackEntriesUsed"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"(node_nf_conntrack_entries{job=\\\"node-exporter\\\"} / node_nf_conntrack_entries_limit) > 0.75\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    annotations = {
      description = "{{ $values.QUERY_RESULT.Value | humanizePercentage }} of conntrack entries are used."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/node/nodehighnumberconntrackentriesused"
      summary     = "Number of conntrack are getting close to the limit."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "NodeMemoryHighUtilization"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"100 - (node_memory_MemAvailable_bytes{job=\\\"node-exporter\\\"} / node_memory_MemTotal_bytes{job=\\\"node-exporter\\\"} * 100) > 90\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "Memory is filling up at {{ $labels.instance }}, has been above 90% for the last 15 minutes, is currently at {{ printf \"%.2f\" $values.QUERY_RESULT.Value }}%.\n"
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/node/nodememoryhighutilization"
      summary     = "Host is running out of memory."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "NodeMemoryMajorPagesFaults"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"rate(node_vmstat_pgmajfault{job=\\\"node-exporter\\\"}[5m]) > 500\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "Memory major pages are occurring at very high rate at {{ $labels.instance }}, 500 major page faults per second for the last 15 minutes, is currently at {{ printf \"%.2f\" $values.QUERY_RESULT.Value }}.\nPlease check that there is enough memory available at this instance.\n"
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/node/nodememorymajorpagesfaults"
      summary     = "Memory major page faults are occurring at very high rate."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "NodeNetworkReceiveErrs"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"rate(node_network_receive_errs_total{job=\\\"node-exporter\\\"}[2m]) / rate(node_network_receive_packets_total{job=\\\"node-exporter\\\"}[2m]) > 0.01\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "1h"
    annotations = {
      description = "{{ $labels.instance }} interface {{ $labels.device }} has encountered {{ printf \"%.0f\" $values.QUERY_RESULT.Value }} receive errors in the last two minutes."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/node/nodenetworkreceiveerrs"
      summary     = "Network interface is reporting many receive errors."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "NodeNetworkTransmitErrs"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"rate(node_network_transmit_errs_total{job=\\\"node-exporter\\\"}[2m]) / rate(node_network_transmit_packets_total{job=\\\"node-exporter\\\"}[2m]) > 0.01\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "1h"
    annotations = {
      description = "{{ $labels.instance }} interface {{ $labels.device }} has encountered {{ printf \"%.0f\" $values.QUERY_RESULT.Value }} transmit errors in the last two minutes."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/node/nodenetworktransmiterrs"
      summary     = "Network interface is reporting many transmit errors."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "NodeRAIDDegraded"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"node_md_disks_required{job=\\\"node-exporter\\\",device=~\\\"(/dev/)?(mmcblk.p.+|nvme.+|rbd.+|sd.+|vd.+|xvd.+|dm-.+|md.+|dasd.+)\\\"}\\n- ignoring (state) (node_md_disks{state=\\\"active\\\",job=\\\"node-exporter\\\",device=~\\\"(/dev/)?(mmcblk.p.+|nvme.+|rbd.+|sd.+|vd.+|xvd.+|dm-.+|md.+|dasd.+)\\\"})\\n> 0\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "RAID array '{{ $labels.device }}' at {{ $labels.instance }} is in degraded state due to one or more disks failures. Number of spare drives is insufficient to fix issue automatically."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/node/noderaiddegraded"
      summary     = "RAID Array is degraded."
    }
    labels = {
      severity = "critical"
    }
    is_paused = false
  }
  rule {
    name      = "NodeRAIDDiskFailure"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"node_md_disks{state=\\\"failed\\\",job=\\\"node-exporter\\\",device=~\\\"(/dev/)?(mmcblk.p.+|nvme.+|rbd.+|sd.+|vd.+|xvd.+|dm-.+|md.+|dasd.+)\\\"} > 0\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    annotations = {
      description = "At least one device in RAID array at {{ $labels.instance }} failed. Array '{{ $labels.device }}' needs attention and possibly a disk swap."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/node/noderaiddiskfailure"
      summary     = "Failed device in RAID array."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "NodeSystemSaturation"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"node_load1{job=\\\"node-exporter\\\"}\\n/ count without (cpu, mode) (node_cpu_seconds_total{job=\\\"node-exporter\\\", mode=\\\"idle\\\"}) > 2\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "System load per core at {{ $labels.instance }} has been above 2 for the last 15 minutes, is currently at {{ printf \"%.2f\" $values.QUERY_RESULT.Value }}.\nThis might indicate this instance resources saturation and can cause it becoming unresponsive.\n"
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/node/nodesystemsaturation"
      summary     = "System saturated, load per core is very high."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "NodeSystemdServiceFailed"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"node_systemd_unit_state{job=\\\"node-exporter\\\", state=\\\"failed\\\"} == 1\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "5m"
    annotations = {
      description = "Systemd service {{ $labels.name }} has entered failed state at {{ $labels.instance }}"
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/node/nodesystemdservicefailed"
      summary     = "Systemd service has entered failed state."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "NodeTextFileCollectorScrapeError"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"node_textfile_scrape_error{job=\\\"node-exporter\\\"} == 1\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    annotations = {
      description = "Node Exporter text file collector on {{ $labels.instance }} failed to scrape."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/node/nodetextfilecollectorscrapeerror"
      summary     = "Node Exporter text file collector failed to scrape."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
}
resource "grafana_rule_group" "rule_group_b02af95348822b6e" {
  org_id           = 1
  name             = "node-network"
  folder_uid       = "ae5qdfq4wjhmod"
  interval_seconds = 300

  rule {
    name      = "NodeNetworkInterfaceFlapping"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"changes(node_network_up{job=\\\"node-exporter\\\",device!~\\\"veth.+\\\"}[2m]) > 2\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "2m"
    annotations = {
      description = "Network interface \"{{ $labels.device }}\" changing its up status often on node-exporter {{ $labels.namespace }}/{{ $labels.pod }}"
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/general/nodenetworkinterfaceflapping"
      summary     = "Network interface is often changing its status"
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
}
resource "grafana_rule_group" "rule_group_62f42bc40024368b" {
  org_id           = 1
  name             = "prometheus"
  folder_uid       = "ae5qdfq4wjhmod"
  interval_seconds = 300

  rule {
    name      = "PrometheusBadConfig"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"max_over_time(prometheus_config_last_reload_successful{job=\\\"prometheus-kube-prometheus-prometheus\\\",namespace=\\\"monitoring\\\"}[5m]) == 0\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "10m"
    annotations = {
      description = "Prometheus {{$labels.namespace}}/{{$labels.pod}} has failed to reload its configuration."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheusbadconfig"
      summary     = "Failed Prometheus configuration reload."
    }
    labels = {
      severity = "critical"
    }
    is_paused = false
  }
  rule {
    name      = "PrometheusDuplicateTimestamps"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"rate(prometheus_target_scrapes_sample_duplicate_timestamp_total{job=\\\"prometheus-kube-prometheus-prometheus\\\",namespace=\\\"monitoring\\\"}[5m]) > 0\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "10m"
    annotations = {
      description = "Prometheus {{$labels.namespace}}/{{$labels.pod}} is dropping {{ printf \"%.4g\" $values.QUERY_RESULT.Value  }} samples/s with different values but duplicated timestamp."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheusduplicatetimestamps"
      summary     = "Prometheus is dropping samples with duplicate timestamps."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "PrometheusErrorSendingAlertsToAnyAlertmanager"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"min without (alertmanager) (\\n  rate(prometheus_notifications_errors_total{job=\\\"prometheus-kube-prometheus-prometheus\\\",namespace=\\\"monitoring\\\",alertmanager!~``}[5m])\\n/\\n  rate(prometheus_notifications_sent_total{job=\\\"prometheus-kube-prometheus-prometheus\\\",namespace=\\\"monitoring\\\",alertmanager!~``}[5m])\\n)\\n* 100\\n> 3\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "{{ printf \"%.1f\" $values.QUERY_RESULT.Value }}% minimum errors while sending alerts from Prometheus {{$labels.namespace}}/{{$labels.pod}} to any Alertmanager."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheuserrorsendingalertstoanyalertmanager"
      summary     = "Prometheus encounters more than 3% errors sending alerts to any Alertmanager."
    }
    labels = {
      severity = "critical"
    }
    is_paused = false
  }
  rule {
    name      = "PrometheusErrorSendingAlertsToSomeAlertmanagers"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"(\\n  rate(prometheus_notifications_errors_total{job=\\\"prometheus-kube-prometheus-prometheus\\\",namespace=\\\"monitoring\\\"}[5m])\\n/\\n  rate(prometheus_notifications_sent_total{job=\\\"prometheus-kube-prometheus-prometheus\\\",namespace=\\\"monitoring\\\"}[5m])\\n)\\n* 100\\n> 1\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "{{ printf \"%.1f\" $values.QUERY_RESULT.Value }}% errors while sending alerts from Prometheus {{$labels.namespace}}/{{$labels.pod}} to Alertmanager {{$labels.alertmanager}}."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheuserrorsendingalertstosomealertmanagers"
      summary     = "Prometheus has encountered more than 1% errors sending alerts to a specific Alertmanager."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "PrometheusHighQueryLoad"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"avg_over_time(prometheus_engine_queries{job=\\\"prometheus-kube-prometheus-prometheus\\\",namespace=\\\"monitoring\\\"}[5m])\\n/ max_over_time(prometheus_engine_queries_concurrent_max{job=\\\"prometheus-kube-prometheus-prometheus\\\",namespace=\\\"monitoring\\\"}[5m])\\n> 0.8\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "Prometheus {{$labels.namespace}}/{{$labels.pod}} query API has less than 20% available capacity in its query engine for the last 15 minutes."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheushighqueryload"
      summary     = "Prometheus is reaching its maximum capacity serving concurrent requests."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "PrometheusKubernetesListWatchFailures"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"increase(prometheus_sd_kubernetes_failures_total{job=\\\"prometheus-kube-prometheus-prometheus\\\",namespace=\\\"monitoring\\\"}[5m]) > 0\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "Kubernetes service discovery of Prometheus {{$labels.namespace}}/{{$labels.pod}} is experiencing {{ printf \"%.0f\" $values.QUERY_RESULT.Value }} failures with LIST/WATCH requests to the Kubernetes API in the last 5 minutes."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheuskuberneteslistwatchfailures"
      summary     = "Requests in Kubernetes SD are failing."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "PrometheusLabelLimitHit"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"increase(prometheus_target_scrape_pool_exceeded_label_limits_total{job=\\\"prometheus-kube-prometheus-prometheus\\\",namespace=\\\"monitoring\\\"}[5m]) > 0\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "Prometheus {{$labels.namespace}}/{{$labels.pod}} has dropped {{ printf \"%.0f\" $values.QUERY_RESULT.Value }} targets because some samples exceeded the configured label_limit, label_name_length_limit or label_value_length_limit."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheuslabellimithit"
      summary     = "Prometheus has dropped targets because some scrape configs have exceeded the labels limit."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "PrometheusMissingRuleEvaluations"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"increase(prometheus_rule_group_iterations_missed_total{job=\\\"prometheus-kube-prometheus-prometheus\\\",namespace=\\\"monitoring\\\"}[5m]) > 0\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "Prometheus {{$labels.namespace}}/{{$labels.pod}} has missed {{ printf \"%.0f\" $values.QUERY_RESULT.Value }} rule group evaluations in the last 5m."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheusmissingruleevaluations"
      summary     = "Prometheus is missing rule evaluations due to slow rule group evaluation."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "PrometheusNotConnectedToAlertmanagers"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"max_over_time(prometheus_notifications_alertmanagers_discovered{job=\\\"prometheus-kube-prometheus-prometheus\\\",namespace=\\\"monitoring\\\"}[5m]) < 1\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "10m"
    annotations = {
      description = "Prometheus {{$labels.namespace}}/{{$labels.pod}} is not connected to any Alertmanagers."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheusnotconnectedtoalertmanagers"
      summary     = "Prometheus is not connected to any Alertmanagers."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "PrometheusNotIngestingSamples"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"(\\n  sum without(type) (rate(prometheus_tsdb_head_samples_appended_total{job=\\\"prometheus-kube-prometheus-prometheus\\\",namespace=\\\"monitoring\\\"}[5m])) <= 0\\nand\\n  (\\n    sum without(scrape_job) (prometheus_target_metadata_cache_entries{job=\\\"prometheus-kube-prometheus-prometheus\\\",namespace=\\\"monitoring\\\"}) > 0\\n  or\\n    sum without(rule_group) (prometheus_rule_group_rules{job=\\\"prometheus-kube-prometheus-prometheus\\\",namespace=\\\"monitoring\\\"}) > 0\\n  )\\n)\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "10m"
    annotations = {
      description = "Prometheus {{$labels.namespace}}/{{$labels.pod}} is not ingesting samples."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheusnotingestingsamples"
      summary     = "Prometheus is not ingesting samples."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "PrometheusNotificationQueueRunningFull"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"(\\n  predict_linear(prometheus_notifications_queue_length{job=\\\"prometheus-kube-prometheus-prometheus\\\",namespace=\\\"monitoring\\\"}[5m], 60 * 30)\\n>\\n  min_over_time(prometheus_notifications_queue_capacity{job=\\\"prometheus-kube-prometheus-prometheus\\\",namespace=\\\"monitoring\\\"}[5m])\\n)\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "Alert notification queue of Prometheus {{$labels.namespace}}/{{$labels.pod}} is running full."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheusnotificationqueuerunningfull"
      summary     = "Prometheus alert notification queue predicted to run full in less than 30m."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "PrometheusOutOfOrderTimestamps"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"rate(prometheus_target_scrapes_sample_out_of_order_total{job=\\\"prometheus-kube-prometheus-prometheus\\\",namespace=\\\"monitoring\\\"}[5m]) > 0\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "10m"
    annotations = {
      description = "Prometheus {{$labels.namespace}}/{{$labels.pod}} is dropping {{ printf \"%.4g\" $values.QUERY_RESULT.Value  }} samples/s with timestamps arriving out of order."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheusoutofordertimestamps"
      summary     = "Prometheus drops samples with out-of-order timestamps."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "PrometheusRemoteStorageFailures"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"(\\n  (rate(prometheus_remote_storage_failed_samples_total{job=\\\"prometheus-kube-prometheus-prometheus\\\",namespace=\\\"monitoring\\\"}[5m]) or rate(prometheus_remote_storage_samples_failed_total{job=\\\"prometheus-kube-prometheus-prometheus\\\",namespace=\\\"monitoring\\\"}[5m]))\\n/\\n  (\\n    (rate(prometheus_remote_storage_failed_samples_total{job=\\\"prometheus-kube-prometheus-prometheus\\\",namespace=\\\"monitoring\\\"}[5m]) or rate(prometheus_remote_storage_samples_failed_total{job=\\\"prometheus-kube-prometheus-prometheus\\\",namespace=\\\"monitoring\\\"}[5m]))\\n  +\\n    (rate(prometheus_remote_storage_succeeded_samples_total{job=\\\"prometheus-kube-prometheus-prometheus\\\",namespace=\\\"monitoring\\\"}[5m]) or rate(prometheus_remote_storage_samples_total{job=\\\"prometheus-kube-prometheus-prometheus\\\",namespace=\\\"monitoring\\\"}[5m]))\\n  )\\n)\\n* 100\\n> 1\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "Prometheus {{$labels.namespace}}/{{$labels.pod}} failed to send {{ printf \"%.1f\" $values.QUERY_RESULT.Value }}% of the samples to {{ $labels.remote_name}}:{{ $labels.url }}"
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheusremotestoragefailures"
      summary     = "Prometheus fails to send samples to remote storage."
    }
    labels = {
      severity = "critical"
    }
    is_paused = false
  }
  rule {
    name      = "PrometheusRemoteWriteBehind"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"(\\n  max_over_time(prometheus_remote_storage_highest_timestamp_in_seconds{job=\\\"prometheus-kube-prometheus-prometheus\\\",namespace=\\\"monitoring\\\"}[5m])\\n- ignoring(remote_name, url) group_right\\n  max_over_time(prometheus_remote_storage_queue_highest_sent_timestamp_seconds{job=\\\"prometheus-kube-prometheus-prometheus\\\",namespace=\\\"monitoring\\\"}[5m])\\n)\\n> 120\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "Prometheus {{$labels.namespace}}/{{$labels.pod}} remote write is {{ printf \"%.1f\" $values.QUERY_RESULT.Value }}s behind for {{ $labels.remote_name}}:{{ $labels.url }}."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheusremotewritebehind"
      summary     = "Prometheus remote write is behind."
    }
    labels = {
      severity = "critical"
    }
    is_paused = false
  }
  rule {
    name      = "PrometheusRemoteWriteDesiredShards"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"(\\n  max_over_time(prometheus_remote_storage_shards_desired{job=\\\"prometheus-kube-prometheus-prometheus\\\",namespace=\\\"monitoring\\\"}[5m])\\n>\\n  max_over_time(prometheus_remote_storage_shards_max{job=\\\"prometheus-kube-prometheus-prometheus\\\",namespace=\\\"monitoring\\\"}[5m])\\n)\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "Prometheus {{$labels.namespace}}/{{$labels.pod}} remote write desired shards calculation wants to run {{ $values.QUERY_RESULT.Value }} shards for queue {{ $labels.remote_name}}:{{ $labels.url }}, which is more than the max of {{ printf `prometheus_remote_storage_shards_max{instance=\"%s\",job=\"prometheus-kube-prometheus-prometheus\",namespace=\"monitoring\"}` $labels.instance | query | first | value }}."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheusremotewritedesiredshards"
      summary     = "Prometheus remote write desired shards calculation wants to run more than configured max shards."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "PrometheusRuleFailures"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"increase(prometheus_rule_evaluation_failures_total{job=\\\"prometheus-kube-prometheus-prometheus\\\",namespace=\\\"monitoring\\\"}[5m]) > 0\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "Prometheus {{$labels.namespace}}/{{$labels.pod}} has failed to evaluate {{ printf \"%.0f\" $values.QUERY_RESULT.Value }} rules in the last 5m."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheusrulefailures"
      summary     = "Prometheus is failing rule evaluations."
    }
    labels = {
      severity = "critical"
    }
    is_paused = false
  }
  rule {
    name      = "PrometheusSDRefreshFailure"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"increase(prometheus_sd_refresh_failures_total{job=\\\"prometheus-kube-prometheus-prometheus\\\",namespace=\\\"monitoring\\\"}[10m]) > 0\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "20m"
    annotations = {
      description = "Prometheus {{$labels.namespace}}/{{$labels.pod}} has failed to refresh SD with mechanism {{$labels.mechanism}}."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheussdrefreshfailure"
      summary     = "Failed Prometheus SD refresh."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "PrometheusScrapeBodySizeLimitHit"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"increase(prometheus_target_scrapes_exceeded_body_size_limit_total{job=\\\"prometheus-kube-prometheus-prometheus\\\",namespace=\\\"monitoring\\\"}[5m]) > 0\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "Prometheus {{$labels.namespace}}/{{$labels.pod}} has failed {{ printf \"%.0f\" $values.QUERY_RESULT.Value }} scrapes in the last 5m because some targets exceeded the configured body_size_limit."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheusscrapebodysizelimithit"
      summary     = "Prometheus has dropped some targets that exceeded body size limit."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "PrometheusScrapeSampleLimitHit"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"increase(prometheus_target_scrapes_exceeded_sample_limit_total{job=\\\"prometheus-kube-prometheus-prometheus\\\",namespace=\\\"monitoring\\\"}[5m]) > 0\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "Prometheus {{$labels.namespace}}/{{$labels.pod}} has failed {{ printf \"%.0f\" $values.QUERY_RESULT.Value }} scrapes in the last 5m because some targets exceeded the configured sample_limit."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheusscrapesamplelimithit"
      summary     = "Prometheus has failed scrapes that have exceeded the configured sample limit."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "PrometheusTSDBCompactionsFailing"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"increase(prometheus_tsdb_compactions_failed_total{job=\\\"prometheus-kube-prometheus-prometheus\\\",namespace=\\\"monitoring\\\"}[3h]) > 0\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "4h"
    annotations = {
      description = "Prometheus {{$labels.namespace}}/{{$labels.pod}} has detected {{$values.QUERY_RESULT.Value | humanize}} compaction failures over the last 3h."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheustsdbcompactionsfailing"
      summary     = "Prometheus has issues compacting blocks."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "PrometheusTSDBReloadsFailing"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"increase(prometheus_tsdb_reloads_failures_total{job=\\\"prometheus-kube-prometheus-prometheus\\\",namespace=\\\"monitoring\\\"}[3h]) > 0\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "4h"
    annotations = {
      description = "Prometheus {{$labels.namespace}}/{{$labels.pod}} has detected {{$values.QUERY_RESULT.Value | humanize}} reload failures over the last 3h."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheustsdbreloadsfailing"
      summary     = "Prometheus has issues reloading blocks from disk."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "PrometheusTargetLimitHit"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"increase(prometheus_target_scrape_pool_exceeded_target_limit_total{job=\\\"prometheus-kube-prometheus-prometheus\\\",namespace=\\\"monitoring\\\"}[5m]) > 0\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "Prometheus {{$labels.namespace}}/{{$labels.pod}} has dropped {{ printf \"%.0f\" $values.QUERY_RESULT.Value }} targets because the number of targets exceeded the configured target_limit."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheustargetlimithit"
      summary     = "Prometheus has dropped targets because some scrape configs have exceeded the targets limit."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "PrometheusTargetSyncFailure"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"increase(prometheus_target_sync_failed_total{job=\\\"prometheus-kube-prometheus-prometheus\\\",namespace=\\\"monitoring\\\"}[30m]) > 0\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "5m"
    annotations = {
      description = "{{ printf \"%.0f\" $values.QUERY_RESULT.Value }} targets in Prometheus {{$labels.namespace}}/{{$labels.pod}} have failed to sync because invalid configuration was supplied."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/prometheus/prometheustargetsyncfailure"
      summary     = "Prometheus has failed to sync targets."
    }
    labels = {
      severity = "critical"
    }
    is_paused = false
  }
}
resource "grafana_rule_group" "rule_group_f9fb49c384896c34" {
  org_id           = 1
  name             = "prometheus-operator"
  folder_uid       = "ae5qdfq4wjhmod"
  interval_seconds = 300

  rule {
    name      = "PrometheusOperatorListErrors"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"(sum by (cluster,controller,namespace) (rate(prometheus_operator_list_operations_failed_total{job=\\\"prometheus-kube-prometheus-operator\\\",namespace=\\\"monitoring\\\"}[10m]))\\n/ sum by (cluster,controller,namespace) (rate(prometheus_operator_list_operations_total{job=\\\"prometheus-kube-prometheus-operator\\\",namespace=\\\"monitoring\\\"}[10m])))\\n> 0.4\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "Errors while performing List operations in controller {{$labels.controller}} in {{$labels.namespace}} namespace."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/prometheus-operator/prometheusoperatorlisterrors"
      summary     = "Errors while performing list operations in controller."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "PrometheusOperatorNodeLookupErrors"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"rate(prometheus_operator_node_address_lookup_errors_total{job=\\\"prometheus-kube-prometheus-operator\\\",namespace=\\\"monitoring\\\"}[5m]) > 0.1\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "10m"
    annotations = {
      description = "Errors while reconciling Prometheus in {{ $labels.namespace }} Namespace."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/prometheus-operator/prometheusoperatornodelookuperrors"
      summary     = "Errors while reconciling Prometheus."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "PrometheusOperatorNotReady"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"min by (cluster,controller,namespace) (max_over_time(prometheus_operator_ready{job=\\\"prometheus-kube-prometheus-operator\\\",namespace=\\\"monitoring\\\"}[5m]) == 0)\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "5m"
    annotations = {
      description = "Prometheus operator in {{ $labels.namespace }} namespace isn't ready to reconcile {{ $labels.controller }} resources."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/prometheus-operator/prometheusoperatornotready"
      summary     = "Prometheus operator not ready"
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "PrometheusOperatorReconcileErrors"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"(sum by (cluster,controller,namespace) (rate(prometheus_operator_reconcile_errors_total{job=\\\"prometheus-kube-prometheus-operator\\\",namespace=\\\"monitoring\\\"}[5m])))\\n/ (sum by (cluster,controller,namespace) (rate(prometheus_operator_reconcile_operations_total{job=\\\"prometheus-kube-prometheus-operator\\\",namespace=\\\"monitoring\\\"}[5m])))\\n> 0.1\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "10m"
    annotations = {
      description = "{{ $values.QUERY_RESULT.Value | humanizePercentage }} of reconciling operations failed for {{ $labels.controller }} controller in {{ $labels.namespace }} namespace."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/prometheus-operator/prometheusoperatorreconcileerrors"
      summary     = "Errors while reconciling objects."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "PrometheusOperatorRejectedResources"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"min_over_time(prometheus_operator_managed_resources{state=\\\"rejected\\\",job=\\\"prometheus-kube-prometheus-operator\\\",namespace=\\\"monitoring\\\"}[5m]) > 0\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "5m"
    annotations = {
      description = "Prometheus operator in {{ $labels.namespace }} namespace rejected {{ printf \"%0.0f\" $values.QUERY_RESULT.Value }} {{ $labels.controller }}/{{ $labels.resource }} resources."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/prometheus-operator/prometheusoperatorrejectedresources"
      summary     = "Resources rejected by Prometheus operator"
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "PrometheusOperatorStatusUpdateErrors"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"(sum by (cluster,controller,namespace) (rate(prometheus_operator_status_update_errors_total{job=\\\"prometheus-kube-prometheus-operator\\\",namespace=\\\"monitoring\\\"}[5m])))\\n/ (sum by (cluster,controller,namespace) (rate(prometheus_operator_status_update_operations_total{job=\\\"prometheus-kube-prometheus-operator\\\",namespace=\\\"monitoring\\\"}[5m])))\\n> 0.1\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "10m"
    annotations = {
      description = "{{ $values.QUERY_RESULT.Value | humanizePercentage }} of status update operations failed for {{ $labels.controller }} controller in {{ $labels.namespace }} namespace."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/prometheus-operator/prometheusoperatorstatusupdateerrors"
      summary     = "Errors while updating objects status."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "PrometheusOperatorSyncFailed"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"min_over_time(prometheus_operator_syncs{status=\\\"failed\\\",job=\\\"prometheus-kube-prometheus-operator\\\",namespace=\\\"monitoring\\\"}[5m]) > 0\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "10m"
    annotations = {
      description = "Controller {{ $labels.controller }} in {{ $labels.namespace }} namespace fails to reconcile {{ $values.QUERY_RESULT.Value }} objects."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/prometheus-operator/prometheusoperatorsyncfailed"
      summary     = "Last controller reconciliation failed"
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
  rule {
    name      = "PrometheusOperatorWatchErrors"
    condition = "ALERTCONDITION"

    data {
      ref_id = "QUERY"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "PBFA97CFB590B2093"
      model          = "{\"editorMode\":\"code\",\"expr\":\"(sum by (cluster,controller,namespace) (rate(prometheus_operator_watch_operations_failed_total{job=\\\"prometheus-kube-prometheus-operator\\\",namespace=\\\"monitoring\\\"}[5m]))\\n/ sum by (cluster,controller,namespace) (rate(prometheus_operator_watch_operations_total{job=\\\"prometheus-kube-prometheus-operator\\\",namespace=\\\"monitoring\\\"}[5m])))\\n> 0.4\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"QUERY\"}"
    }
    data {
      ref_id = "QUERY_RESULT"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"QUERY_RESULT\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "ALERTCONDITION"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"QUERY_RESULT\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"QUERY_RESULT\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"ALERTCONDITION\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "Errors while performing watch operations in controller {{$labels.controller}} in {{$labels.namespace}} namespace."
      runbook_url = "https://runbooks.prometheus-operator.dev/runbooks/prometheus-operator/prometheusoperatorwatcherrors"
      summary     = "Errors while performing watch operations in controller."
    }
    labels = {
      severity = "warning"
    }
    is_paused = false
  }
}
