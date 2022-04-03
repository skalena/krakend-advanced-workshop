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