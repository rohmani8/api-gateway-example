FROM devopsfaith/krakend:2.3.1 as builder
ARG ENV=dev

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

FROM devopsfaith/krakend:2.3.1
COPY --from=builder /etc/krakend/output.json ./krakend.json
RUN chown root:root -R ./krakend.json
RUN chmod 775 -R ./krakend.json
