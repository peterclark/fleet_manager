OSQUERY_CONFIG = {
  "tls_plugin": {
    "schedule": {
      "test_query": {
        "interval": "5",
        "description": "test query",
        "query": "SELECT * FROM processes;"
      }
    }
  }
}