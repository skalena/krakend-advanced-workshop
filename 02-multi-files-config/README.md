![skalena-logo](https://static.wixstatic.com/media/6bd302_9111478163da47e1922199a6ed6d6c02~mv2.png/v1/crop/x_0,y_13,w_1681,h_363/fill/w_362,h_78,al_c,usm_0.66_1.00_0.01,enc_auto/skalena_Agua.png)
# KrakenD Tutorial - Multi-Files Config

We will use the same approach from the previous sample(https://github.com/skalena/krakend-advanced-workshop/tree/main/01-env-vars), we believe that this approach to use a file to keep the variables and information can be one for the best practices for managing the config in a more dynamic way. 

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
    │   └── static_file.tmpl
    ├── settings
    │   ├── dev
    │   │   └── db.json
    │   └── prod
    │       └── db.json
    └── templates
        └── environments.tmpl
```

We will be able to split parts of the KrakenD config among different developers, or squads, unify with configs from the Devops team, so you have all this flexibility in your hands. 

