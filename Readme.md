# Make password
HASH=`(PASSWORD="mypassword";SALT="$(openssl rand -base64 3)";SHA1=$(printf "$PASSWORD$SALT" | openssl dgst -binary -sha1 | sed 's#$#'"$SALT"'#' | base64);printf "{SSHA}$SHA1\n")`
echo 'mon':$HASH > /etc/.nginx-htpasswd

# Postgresql 
docker run --rm -ti -e DATA_SOURCE_NAME="postgresql://postgres:db.mega.super.pwd@db.dev.wumvi.com:5432/?sslmode=disable" --net=wumvi-net-dev -p 9187:9187 wrouesnel/postgres_exporter

# Container exporter
docker run -p 9104:9104 -v /sys/fs/cgroup:/cgroup -v /var/run/docker.sock:/var/run/docker.sock prom/container-exporter

# nginx
docker run  -ti --rm --env NGINX_STATUS="http://www.dev.wumvi.com:8181/status/format/json" --net=wumvi-net-dev -p 9104:9913 sophos/nginx-vts-exporter

# sql
docker run -ti --rm -p 5000:5000 --net=wumvi-net-dev dbhi/sql-agent


curl -H "Content-Type: application/json" -X POST -d '{"driver": "postgres", "connection": {"host": "db.dev.wumvi.com", "user": "wumvi", "password":"devwumvipwd", "database":"wumvi"}, "sql": "SELECT * from users"}' http://192.168.96.107:5000/

{"driver": "postgres", "connection": {"host": "db.dev.wumvi.com", "user": "wumvi", "password":"devwumvipwd", "database":"wumvi"}, "sql": "SELECT 1111"}

#
docker run -ti --rm -p 9970:9970 -v /root/configs/promsql/prometheus-sql.yml:/prometheus-sql.yml -v /root/configs/promsql/queries.yml:/queries.yml --net=wumvi-net-dev dbhi/prometheus-sql -port 9970 -service http://192.168.96.107:5000 -config prometheus-sql.yml