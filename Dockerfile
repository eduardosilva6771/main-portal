FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .

ARG AUTH0_DOMAIN=replace-me.invalid
ARG AUTH0_CLIENT_ID=replace-me
ARG AUTH0_AUDIENCE=https://replace-me.invalid/api
ARG LOGIN_PORTAL_URL=https://replace-me.invalid/login/
ARG COST_CENTER_PORTAL_URL=https://replace-me.invalid/cost-center/
ARG TENANT_PORTAL_URL=https://replace-me.invalid/tenant/
ARG ENTRY_TYPE_PORTAL_URL=https://replace-me.invalid/entry-type/
ARG PAYMENT_METHOD_PORTAL_URL=https://replace-me.invalid/payment-method/

RUN flutter build web --release \
    --dart-define=AUTH0_DOMAIN=${AUTH0_DOMAIN} \
    --dart-define=AUTH0_CLIENT_ID=${AUTH0_CLIENT_ID} \
    --dart-define=AUTH0_AUDIENCE=${AUTH0_AUDIENCE} \
    --dart-define=LOGIN_PORTAL_URL=${LOGIN_PORTAL_URL} \
    --dart-define=COST_CENTER_PORTAL_URL=${COST_CENTER_PORTAL_URL} \
    --dart-define=TENANT_PORTAL_URL=${TENANT_PORTAL_URL} \
    --dart-define=ENTRY_TYPE_PORTAL_URL=${ENTRY_TYPE_PORTAL_URL} \
    --dart-define=PAYMENT_METHOD_PORTAL_URL=${PAYMENT_METHOD_PORTAL_URL}

FROM nginx:1.27-alpine AS runtime

ENV PORT=8080

COPY deploy/nginx/default.conf.template /etc/nginx/templates/default.conf.template
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 8080
