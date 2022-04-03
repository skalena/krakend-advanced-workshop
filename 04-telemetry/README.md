![skalena-logo](https://static.wixstatic.com/media/6bd302_9111478163da47e1922199a6ed6d6c02~mv2.png/v1/crop/x_0,y_13,w_1681,h_363/fill/w_362,h_78,al_c,usm_0.66_1.00_0.01,enc_auto/skalena_Agua.png)

# KrakenD Tutorial - Telemetry (Jaeger) 
First of all, you must have the Jaeger executing in your machine, please, check the docker execution according the oficial doc:

```
docker run -d --name jaeger \
  -e COLLECTOR_ZIPKIN_HOST_PORT=:9411 \
  -p 5775:5775/udp \
  -p 6831:6831/udp \
  -p 6832:6832/udp \
  -p 5778:5778 \
  -p 16686:16686 \
  -p 14250:14250 \
  -p 14268:14268 \
  -p 14269:14269 \
  -p 9411:9411 \
  jaegertracing/all-in-one:1.32
```
Referência: https://www.jaegertracing.io/docs/1.32/getting-started/ 

Please, open the Web UI from this address: http://localhost:16686/search 

## Configuring KrakenD with Jaeger 

Keep in mind how to execute KrakenD via Docker: 
```
docker run -p 8080:8080 -v $PWD:/etc/krakend/ devopsfaith/krakend
```

Testing the endpoint: ```curl -i http://localhost:8080/jobs/backend```

Check the configuration for Jaeger: 

```json
    "github_com/devopsfaith/krakend-opencensus": {
        "exporters": {
          "jaeger": {
              "endpoint": "http://localhost:14268/api/traces",
              "service_name":"krakend"
          }
        }
      },
```


## Some Loading Testing
We love this tool: Hey(https://github.com/rakyll/hey), which is a pretty easy HTTP Load testing tool.

We will execute 1200 requests now, and check how KrakenD will process this volume:

```hey -n 1200 http://localhost:8080/jobs/backend```

See the results: 

```
Summary:
  Total:        1.6197 secs
  Slowest:      0.7121 secs
  Fastest:      0.0311 secs
  Average:      0.0662 secs
  Requests/sec: 740.8571
  
  Total data:   291948 bytes
  Size/request: 243 bytes

Response time histogram:
  0.031 [1]     |
  0.099 [1149]  |■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
  0.167 [0]     |
  0.235 [0]     |
  0.303 [0]     |
  0.372 [0]     |
  0.440 [0]     |
  0.508 [0]     |
  0.576 [0]     |
  0.644 [0]     |
  0.712 [50]    |■■


Latency distribution:
  10% in 0.0354 secs
  25% in 0.0368 secs
  50% in 0.0387 secs
  75% in 0.0405 secs
  90% in 0.0434 secs
  95% in 0.0476 secs
  99% in 0.7067 secs

Details (average, fastest, slowest):
  DNS+dialup:   0.0002 secs, 0.0311 secs, 0.7121 secs
  DNS-lookup:   0.0001 secs, 0.0000 secs, 0.0030 secs
  req write:    0.0000 secs, 0.0000 secs, 0.0017 secs
  resp wait:    0.0614 secs, 0.0311 secs, 0.6000 secs
  resp read:    0.0045 secs, 0.0000 secs, 0.1214 secs

Status code distribution:
  [200] 52 responses
  [403] 848 responses
  [429] 300 responses

```
