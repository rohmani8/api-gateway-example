FROM devopsfaith/krakend:2.2 as builder
ARG ENV=dev

COPY config/krakend/krakend.tmpl .
COPY config/krakend .

## Save temporary file to /tmp to avoid permission errors
RUN FC_ENABLE=1 \
    FC_OUT="/etc/krakend/output.json" \
    FC_PARTIALS="/etc/krakend/partials" \
    FC_SETTINGS="/etc/krakend/settings/dev" \
    FC_TEMPLATES="/etc/krakend/templates" \
    krakend check -d -t -c krakend.json

# The linting needs the final krakend.json file
RUN krakend check -c /etc/krakend/output.json --lint

FROM devopsfaith/krakend
COPY --from=builder --chown=krakend /etc/krakend/output.json .

EXPOSE 8080

# Uncomment with Enterprise image:
# COPY LICENSE /etc/krakend/LICENSE
