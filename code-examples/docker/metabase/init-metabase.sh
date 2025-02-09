#!/bin/sh -e

ADMIN_FIRST_NAME=${MB_ADMIN_FIRST_NAME:-Administrator}
ADMIN_LAST_NAME=${MB_ADMIN_LAST_NAME:-Administrator}
ADMIN_EMAIL=${MB_ADMIN_EMAIL:-admin@metabase.local}
ADMIN_PASSWORD=${MB_ADMIN_PASSWORD:-SuperSecurePassword123456!}

METABASE_HOST=${MB_HOSTNAME:-metabase}
METABASE_PORT=${MB_PORT:-3000}

SITE_NAME=${MB_SITE_NAME:-"MetabaseDemo"}

if [ -f ./.init-done ]; then
  echo "Metabase init script has already run. Remove the file ./.init-done to run this script again.";
  exit 0;
fi;

echo "Waiting for Metabase to be ready...";
while (! curl -s -m 5 http://${METABASE_HOST}:${METABASE_PORT}/api/session/properties -o /dev/null); do sleep 5; done

printf "Obtaining setup token...";
SETUP_TOKEN=$(curl -s -m 5 -X GET \
    http://${METABASE_HOST}:${METABASE_PORT}/api/session/properties \
    -H "Content-Type: application/json" \
    | jq -r '.["setup-token"]') && printf ' [OK]\n' || printf ' [FAIL]\n';

printf "Creating admin user...";
MB_TOKEN=$(curl -s -X POST \
    http://${METABASE_HOST}:${METABASE_PORT}/api/setup \
    -H "Content-type: application/json" \
    -d '{
    "token": "'${SETUP_TOKEN}'",
    "user": {
        "email": "'${ADMIN_EMAIL}'",
        "first_name": "'${ADMIN_FIRST_NAME}'",
        "last_name": "'${ADMIN_LAST_NAME}'",
        "password": "'${ADMIN_PASSWORD}'"
    },
    "prefs": {
        "allow_tracking": false,
        "site_name": "'${SITE_NAME}'"
    }
}' | jq -r '.id') && printf ' [OK]\n' || printf ' [FAIL]\n';

# echo -e "\n Creating some basic users: "
# curl -s "http://${METABASE_HOST}:${METABASE_PORT}/api/user" \
#     -H 'Content-Type: application/json' \
#     -H "X-Metabase-Session: ${MB_TOKEN}" \
#     -d '{"first_name":"Basic","last_name":"User","email":"basic@somewhere.com","login_attributes":{"region_filter":"WA"},"password":"'${ADMIN_PASSWORD}'"}'

# curl -s "http://${METABASE_HOST}:${METABASE_PORT}/api/user" \
#     -H 'Content-Type: application/json' \
#     -H "X-Metabase-Session: ${MB_TOKEN}" \
#     -d '{"first_name":"Basic 2","last_name":"User","email":"basic2@somewhere.com","login_attributes":{"region_filter":"CA"},"password":"'${ADMIN_PASSWORD}'"}'
# echo -e "\n Basic users created!"

printf "Configuring SMTP server...";
curl -s "http://${METABASE_HOST}:${METABASE_PORT}/api/email" \
     -X PUT \
     -H 'Content-Type: application/json' \
     -H "X-Metabase-Session: ${MB_TOKEN}" \
     --data-raw '{
        "email-smtp-host": "metabase_mailpit",
        "email-smtp-port": 1025,
        "email-smtp-security": "tls",
        "email-smtp-username": "mailpituser1",
        "email-smtp-password": "mailpitpassword1"
      }' && printf ' [OK]\n' || printf ' [FAIL]\n';

printf "Configuring Database 1...";
curl  -s http://${METABASE_HOST}:${METABASE_PORT}/api/database \
      -X POST \
      -H 'Content-Type: application/json' \
      -H "X-Metabase-Session: ${MB_TOKEN}" \
      -d '{
        "is_on_demand": false,
        "is_full_sync": true,
        "is_sample": false,
        "cache_ttl": null,
        "refingerprint": false,
        "auto_run_queries": true,
        "schedules": {},
        "details": {
          "host": "metabase_demo_database_1",
          "port": 5432,
          "dbname": "demo-database-1-db",
          "user": "demo-database-1-user",
          "password": "demo-database-1-password",
          "schema-filters-type": "inclusion",
          "schema-filters-patterns": "public",
          "ssl": true,
          "ssl-mode": "prefer",
          "ssl-use-client-auth": false,
          "tunnel-enabled": false,
          "advanced-options": false
        },
        "name": "Metabase Demo Database 1",
        "engine": "postgres"
      }' && printf ' [OK]\n' || printf ' [FAIL]\n';

printf "Configuring Database 2...";
curl  -s http://${METABASE_HOST}:${METABASE_PORT}/api/database \
      -X POST \
      -H 'Content-Type: application/json' \
      -H "X-Metabase-Session: ${MB_TOKEN}" \
      -d '{
        "is_on_demand": false,
        "is_full_sync": true,
        "is_sample": false,
        "cache_ttl": null,
        "refingerprint": false,
        "auto_run_queries": true,
        "schedules": {},
        "details": {
          "host": "metabase_demo_database_2",
          "port": 3306,
          "dbname": "demo-database-2-db",
          "user": "demo-database-2-user",
          "password": "demo-database-2-password",
          "ssl": false,
          "tunnel-enabled": false,
          "advanced-options": true,
          "json-unfolding": true,
          "additional-options": "allowPublicKeyRetrieval=true",
          "let-user-control-scheduling": false
        },
        "name": "Metabase Demo Database 2",
        "engine": "mysql"
      }' && printf ' [OK]\n' || printf ' [FAIL]\n';

touch ./.init-done