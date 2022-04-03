![skalena-logo](https://static.wixstatic.com/media/6bd302_9111478163da47e1922199a6ed6d6c02~mv2.png/v1/crop/x_0,y_13,w_1681,h_363/fill/w_362,h_78,al_c,usm_0.66_1.00_0.01,enc_auto/skalena_Agua.png)
# KrakenD Tutorial - Multi-Files Config

We will use the same approach from the previous [sample](https://github.com/skalena/krakend-advanced-workshop/tree/main/01-env-vars), we believe that this approach to use a file to keep the variables and information can be one for the best practices for managing the config in a more dynamic way.

The references for this can be found here: https://www.krakend.io/docs/configuration/flexible-config/

# Getting Started 

In the following image, you can see the structure for your dynamic pieces, in order to generate a kind of live/dynamic config file: 

![enter image description here](https://www.krakend.io/images/krakend-flexible-config.png)

The structure of your folder will be: 
```
.
├── README.md
└── config
    ├── krakend.json
    ├── partials
    │   └── <PARTS FROM CONFIG>
    ├── settings
    │   ├── dev
    │   │   └── .JSON with configs
    │   └── prod
    │       └── .JSON with configs
    └── templates
        └── TEMPLATES
```

We will be able to split parts of the KrakenD config among different developers, or squads, unify with configs from the Devops team, so you have all this flexibility in your hands. 

## Hands on time
We will have the following structure for our example:

    .
    ├── README.md
    ├── config
    │   ├── krakend.json
    │   ├── partials
    │   │   └── rate_limit_backend.tmpl.  (will be used for backends)
    │   ├── settings
    │   │   ├── endpoint.json - list of endpoints
    │   │   └── service.json - information about the api
    │   └── templates
    │       └── environments.tmpl - a template
    ├── out.json
    └── run-multiconfig-krakend.sh - our simple script

First, we will do using just the **KrakenD binary** (CLI in terminal) . 

Check the content from `rate_limit_backend.tmpl`: 
```json
        "qos/ratelimit/proxy": {
               "max_rate": "100",
               "capacity": "100"
        }
```        
This is a portion that will be included as is into our krakend.json config file as plan it is , for that reason, into the krakend.json template, you will if referred like that: 
```json
    "extra_config": {
    
    {{  include  "rate_limit_backend.tmpl" }}
    
    }
```
The other file is the ```service.json``` inside the settings folder, this file has the following structure: 
```json
    {
        "port": 8080,
        "default_hosts": [
            "https://api.github.com"
        ],
        "extra_config": {
    
        }
    }
```
In this file, as you can see there are information about the port property and also a list of potential hosts for our services. 

For the endpoints, we have the config file called: `endpoint.json` , which has a list of the endpoints that we will add, in this file, we have the endpoint address and the URI from the backend living in the configured host from the previous step: 

```json
{
    "example_group": [
        {
            "endpoint": "/jobs/backend",
            "backend": "/repos/backend-br/vagas/issues"
        },
        {
            "endpoint": "/jobs/frontend",
            "backend": "/repos/frontendbr/vagas/issues"
        }
    ]
}
```

We can play as we want when we are building the configs, properties and template files. 

## Putting all together
It's time to grab the whole files and generate an unique `krakend.json`, in order to do that, we have the following krakend.json template: 

```json showLineNumbers
{
    "version": 3,
    "output_encoding": "no-op",
    "port": {{ .service.port }},
    "extra_config": {{ marshal .service.extra_config }},
    "host": {{ marshal .service.default_hosts }},
    "endpoints": [
        {{ range $idx, $endpoint := .endpoint.example_group }}
        {{if $idx}},{{end}}
        {
        "endpoint": "{{ $endpoint.endpoint }}",
        "output_encoding": "no-op",
        "backend": [
            {
                "url_pattern": "{{ $endpoint.backend }}",
                "encoding": "no-op",
                "extra_config": {
                    {{ include "rate_limit_backend.tmpl" }}
                }
            }
        ]}
        {{ end }}
    ]
}
```
You can use the potential of these techniques to generate the config files. 

![examples](https://github.com/edgars/generiquisses/raw/master/img/prnt-post-krakned.png)

## Script execution

In order to make sure that the env variables are settled properly and also to streamline the KrakenD runtime execution. 

```terminal
export FC_ENABLE=1 
export FC_SETTINGS="config/settings" 
export FC_PARTIALS="config/partials" 
export FC_TEMPLATES="config/templates"  
export FC_OUT=out.json

krakend run -c config/krakend.json
```

In order to execute the script, please: 

```
./run-multiconfig-krakend.sh
```

## Running the Example

Here is a example in how to execute that example:

```console
curl -i http://localhost:8080/jobs/backend
```