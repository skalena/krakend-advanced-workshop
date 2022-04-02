export FC_ENABLE=1 
export FC_SETTINGS="config/settings" 
export FC_PARTIALS="config/partials" 
export FC_TEMPLATES="config/templates"  
export FC_OUT=out.json

krakend run -c config/krakend.json

#krakend check -t -d -c config/krakend.json