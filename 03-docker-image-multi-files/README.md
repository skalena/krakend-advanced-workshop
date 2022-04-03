![skalena-logo](https://static.wixstatic.com/media/6bd302_9111478163da47e1922199a6ed6d6c02~mv2.png/v1/crop/x_0,y_13,w_1681,h_363/fill/w_362,h_78,al_c,usm_0.66_1.00_0.01,enc_auto/skalena_Agua.png)
# KrakenD Tutorial - Dockerfile for Multi-Files Config

Using the principles from the previous [sample](https://github.com/skalena/krakend-advanced-workshop/tree/main/03-docker-image-multi-files), now we will create a Docker Image to encapsulate everything in a docker image that will be executed as a Docker instance with everything you need for expose your APIs using KrakenD API Gateway: 

![examples](https://github.com/edgars/generiquisses/raw/master/img/prnt-post-krakned.png)

## Bulding the Dockerfile
A good approach is to test the configurations using the ```KrakenD binary```, and then move it to the Docker images. In that case, see the following Dockerimage file: 

```
FROM devopsfaith/krakend

COPY config/krakend.json /etc/krakend/krakend.json
COPY config/settings/**  /etc/krakend/config/settings/
COPY config/partials/**  /etc/krakend/config/partials/
COPY config/templates/**  /etc/krakend/config/templates/

ENV FC_ENABLE=1 
ENV FC_SETTINGS="/etc/krakend/config/settings" 
ENV FC_PARTIALS="/etc/krakend/config/partials" 
ENV FC_TEMPLATES="/etc/krakend/config/templates"  


ENTRYPOINT [ "/usr/bin/krakend" ]
CMD [ "run", "-c", "/etc/krakend/krakend.json"]
```

You have to build the Docker image, as an example you can see the following code snippet: 

```
docker build -t skalenatech/workshop-adv-03 . 
```
And then, executing de Docker image: 
```
docker run -p 8080:8080 skalenatech/workshop-adv-03
```

## Best Practices

One of the best practices for KrakenD is encapsulate the services as Docker Images, it keeps the configuration in a more immutable fashion.

Oficial Documentation reference:

* https://www.krakend.io/docs/configuration/flexible-config/
* https://www.krakend.io/docs/deploying/docker/
