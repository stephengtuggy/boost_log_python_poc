ARG  from
FROM ${from}
LABEL authors="Stephen G. Tuggy"

WORKDIR /usr/local/src/boost_log_python_poc

COPY . .

ENTRYPOINT ["script/docker-entrypoint.sh"]
