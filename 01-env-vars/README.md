![skalena-logo](https://static.wixstatic.com/media/6bd302_9111478163da47e1922199a6ed6d6c02~mv2.png/v1/crop/x_0,y_13,w_1681,h_363/fill/w_362,h_78,al_c,usm_0.66_1.00_0.01,enc_auto/skalena_Agua.png)
# KrakenD Tutorial - Using Environment Variables
When you are running krakenD as standard Docker Image provided by DevopsFaith, you can use  a kind of markup/scripting variables in the krakend.json file in order to get dynamic values, that can be based into the environment variables. 

In order to do that, in the portion where you want o use a value from a env var, you can use the following tag: 
```json
{{ env MY_VAR }} 
```

Anywhere you have this in the krakend.json, it will get the env variable value from the context, you can set this environment variable, as simple as `export MY_VAR=foo` ,  but as we are using Docker, we recommend you to use a file which will contain the whole env variables to be used. 

I our example we have the file env.list, which the following content:

    FC_ENABLE=1
    ENDPOINT=https://viacep.com.br/

The first variable (`FC_ENABLE=1`)  tells to KrakenD runtime, that it has to manage dynamic information in to the krakend.json file, in further examples, we can do so many great things with that.  And the second variable is: `ENDPOINT`. In our krakend.json, the host for the Endpoints we let it to be settled according to the environment, for that reason, we have this in that specific section: 

    "host": [
    
    "{{ env "ENDPOINT" }}"
    
    ],

Think about the wide range of possibilities you can use it to make your deployment and even coding faster and simpler. 

# Executing
When you will go to execute the Docker image informing the env file, you have to run KrakenD docker image as the following: 

    docker run --env-file env.list -p 8080:8080 -v $PWD:/etc/krakend/ devopsfaith/krakend

You will be able to see the logs, and check that KrakenD has been started successfully 

In order to test:
```terminal
curl -i http://localhost:8080/v1/cep/04548020
```
We hope you had liked this. 