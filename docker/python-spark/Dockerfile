FROM jupyter/pyspark-notebook:spark-3.5.0

USER root

# Installer JDK 17
RUN apt-get update && \
    apt-get install -y openjdk-17-jdk curl unzip && \
    update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-17-openjdk-amd64/bin/java 1 && \
    update-alternatives --set java /usr/lib/jvm/java-17-openjdk-amd64/bin/java

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

# Installer Hadoop 2.10.2
ENV HADOOP_VERSION=2.10.2
ENV HADOOP_HOME=/opt/hadoop
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin

RUN curl -fSL https://downloads.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz -o /tmp/hadoop.tar.gz && \
    tar -xzf /tmp/hadoop.tar.gz -C /opt && \
    mv /opt/hadoop-${HADOOP_VERSION} $HADOOP_HOME && \
    rm /tmp/hadoop.tar.gz

# Télécharger winutils.exe (utile même dans conteneur pour compatibilité)
RUN mkdir -p $HADOOP_HOME/bin && \
    curl -Lo $HADOOP_HOME/bin/winutils.exe https://github.com/cdarlint/winutils/raw/master/hadoop-2.10.2/bin/winutils.exe && \
    chmod +x $HADOOP_HOME/bin/winutils.exe

# Installer bibliothèques Python utiles
RUN pip install --no-cache-dir \
    psycopg2-binary \
    mysql-connector-python \
    requests \
    boto3 \
    sqlalchemy \
    python-dotenv

# Télécharger les drivers JDBC (PostgreSQL + MySQL)
RUN mkdir -p /usr/local/spark/jars && \
    curl -L -o /usr/local/spark/jars/postgresql-42.6.0.jar https://jdbc.postgresql.org/download/postgresql-42.6.0.jar && \
    curl -L -o /usr/local/spark/jars/mysql-connector-j-8.3.0.jar https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.3.0/mysql-connector-j-8.3.0.jar

USER $NB_UID
