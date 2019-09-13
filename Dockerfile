FROM python:3.6
WORKDIR /app

RUN apt-get update && apt-get install -y mongo-tools gettext libldap2-dev libsasl2-dev
COPY requirements.txt /app/requirements.txt
RUN pip install -r requirements.txt && pip install uwsgi python-ldap

COPY . /app
RUN adduser --uid 1001 --system alerta && chown -R 1001 /app /home/alerta
USER alerta

ENV ALERTA_SVR_CONF_FILE /app/alertad.conf
ENV ALERTA_CONF_FILE /app/alerta.conf
ENV BASE_URL /
ENV INSTALL_PLUGINS ""
ENV PYTHONUNBUFFERED 1
ENV PYTHONPATH=/app

ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["uwsgi", "--ini", "/app/uwsgi.ini"]
