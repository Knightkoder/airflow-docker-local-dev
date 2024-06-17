FROM apache/airflow:2.6.3
USER root

ARG AIRFLOW_HOME=/opt/airflow
ADD dags /opt/airflow/dags

COPY key.json /opt/airflow/key.json
RUN export GOOGLE_APPLICATION_CREDENTIALS="/opt/airflow/key.json"

RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && apt-get update -y && apt-get install google-cloud-sdk -y
USER airflow
RUN pip install --upgrade pip
RUN pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org boto3

USER ${AIRFLOW_UID}
