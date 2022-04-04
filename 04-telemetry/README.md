![skalena-logo](https://static.wixstatic.com/media/6bd302_9111478163da47e1922199a6ed6d6c02~mv2.png/v1/crop/x_0,y_13,w_1681,h_363/fill/w_362,h_78,al_c,usm_0.66_1.00_0.01,enc_auto/skalena_Agua.png)

# KrakenD Tutorial - Telemetry (Jaeger) 
In order to execute this tutorial, you must have Docker and Docker composer installed into your machine: 

```
version: "3"
services:
  jaeger:
    image: jaegertracing/all-in-one:1.32
    ports:
      - "16686:16686"
      - "5775:5775/udp" 
      - "6831:6831/udp" 
      - "6832:6832/udp" 
      - "5778:5778" 
      - "14250:14250" 
      - "14268:14268" 
      - "14269:14269" 
      - "9411:9411"
    environment:
    - COLLECTOR_ZIPKIN_HOST_PORT=:9411      
  krakend_ce:
    image: devopsfaith/krakend:latest
    volumes:
      - .:/etc/krakend
    ports:
      - "1234:1234"
      - "8080:8080"
      - "8090:8090"
    command: ["run", "-d", "-c", "/etc/krakend/krakend.json"]
    depends_on:
      - jaeger
```
Referência: https://www.jaegertracing.io/docs/1.32/getting-started/ 

## Executing the Docker compose
In the root folder where the docker-compose.yml file is, please execute the following command: 

```
docker compose up
```


Please, open the Web UI from this address: http://localhost:16686/search 



## Configuring KrakenD with Jaeger 

In the previous step you had started both Jaeger and KrakenD, and now , you will have both services up and running, so you can test if KrakenD is running with the following command: 

```curl -i http http://localhost:8080/bff/4```

The result will be the composition of 2 backends, responding to just one resource, in that case ```/bff{user_id}```. 

In the KrakenD config file, you can check where the portion regarding Jaeger was added into the service-level config: 

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

We will execute 100 requests simultaneously now, and check how KrakenD will process this volume:

```hey -n 100 http://localhost:8080/bff/1```

See the results: 

```
Summary:
  Total:        0.1863 secs
  Slowest:      0.1544 secs
  Fastest:      0.0235 secs
  Average:      0.0851 secs
  Requests/sec: 536.6739
  
  Total data:   66800 bytes
  Size/request: 668 bytes

Response time histogram:
  0.023 [1]     |■
  0.037 [41]    |■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
  0.050 [7]     |■■■■■■■
  0.063 [1]     |■
  0.076 [0]     |
  0.089 [0]     |
  0.102 [0]     |
  0.115 [0]     |
  0.128 [8]     |■■■■■■■■
  0.141 [22]    |■■■■■■■■■■■■■■■■■■■■■
  0.154 [20]    |■■■■■■■■■■■■■■■■■■■■


Latency distribution:
  10% in 0.0274 secs
  25% in 0.0322 secs
  50% in 0.1218 secs
  75% in 0.1392 secs
  90% in 0.1473 secs
  95% in 0.1483 secs
  99% in 0.1544 secs

Details (average, fastest, slowest):
  DNS+dialup:   0.0040 secs, 0.0235 secs, 0.1544 secs
  DNS-lookup:   0.0018 secs, 0.0000 secs, 0.0041 secs
  req write:    0.0001 secs, 0.0000 secs, 0.0037 secs
  resp wait:    0.0809 secs, 0.0234 secs, 0.1440 secs
  resp read:    0.0000 secs, 0.0000 secs, 0.0001 secs

Status code distribution:
  [200] 100 responses


```

Now, it is time to check the data that KrakenD had sent to Jaeger :

![examples](https://github.com/edgars/generiquisses/raw/master/img/jaeger_01.png)

And: 

![img 2](https://github.com/edgars/generiquisses/raw/master/img/Jaeger02_2.png)

Done, now your APIs are ready to move like: 

![img 2](https://c.tenor.com/nIs0Zi0OE7wAAAAC/start-me.gif)