FROM jupyter/pyspark-notebook:spark-3.5.0

USER root

# =====================================================
# 🧱 1. Installer JDK 17
# =====================================================
RUN apt-get update && \
    apt-get install -y openjdk-17-jdk curl unzip && \
    update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-17-openjdk-amd64/bin/java 1 && \
    update-alternatives --set java /usr/lib/jvm/java-17-openjdk-amd64/bin/java

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

# =====================================================
# 🧱 2. Installer Hadoop 3.3.6
# =====================================================
ENV HADOOP_VERSION=3.3.6
ENV HADOOP_HOME=/opt/hadoop
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin

RUN curl -fSL https://downloads.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz -o /tmp/hadoop.tar.gz && \
    tar -xzf /tmp/hadoop.tar.gz -C /opt && \
    mv /opt/hadoop-${HADOOP_VERSION} $HADOOP_HOME && \
    rm /tmp/hadoop.tar.gz

# =====================================================
# 🧪 3. Installer bibliothèques Python utiles
# =====================================================
RUN pip install --no-cache-dir \
    psycopg2-binary \
    mysql-connector-python \
    requests \
    boto3 \
    sqlalchemy \
    python-dotenv

# =====================================================
# 🔌 4. Télécharger les drivers JDBC (PostgreSQL + MySQL)
# =====================================================
RUN mkdir -p /usr/local/spark/jars && \
    curl -L -o /usr/local/spark/jars/postgresql-42.6.0.jar https://jdbc.postgresql.org/download/postgresql-42.6.0.jar && \
    curl -L -o /usr/local/spark/jars/mysql-connector-j-8.3.0.jar https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.3.0/mysql-connector-j-8.3.0.jar

# =====================================================
# ☁️ 5. Nettoyer tous les anciens JARs Hadoop/S3A
# =====================================================
RUN find /usr/local/spark/jars -name "*hadoop*.jar" ! -name "*3.3.6*" ! -name "parquet-hadoop-*.jar" -delete && \
    rm -f /usr/local/spark/jars/aws-java-sdk-*.jar

# =====================================================
# ☁️ 6. Ajouter connecteurs Hadoop S3A pour MinIO
# =====================================================
RUN curl -L -o /usr/local/spark/jars/hadoop-aws-3.3.6.jar https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.3.6/hadoop-aws-3.3.6.jar && \
    curl -L -o /usr/local/spark/jars/aws-java-sdk-bundle-1.12.262.jar https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.12.262/aws-java-sdk-bundle-1.12.262.jar && \
    curl -L -o /usr/local/spark/jars/hadoop-common-3.3.6.jar https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-common/3.3.6/hadoop-common-3.3.6.jar \
    curl -L -o /usr/local/spark/jars/parquet-hadoop-1.13.1.jar https://repo1.maven.org/maven2/org/apache/parquet/parquet-hadoop/1.13.1/parquet-hadoop-1.13.1.jar

# Ajouter les JARs Hadoop client nécessaires en version 3.3.6
RUN curl -L -o /usr/local/spark/jars/hadoop-client-api-3.3.6.jar https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-client-api/3.3.6/hadoop-client-api-3.3.6.jar && \
    curl -L -o /usr/local/spark/jars/hadoop-client-runtime-3.3.6.jar https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-client-runtime/3.3.6/hadoop-client-runtime-3.3.6.jar && \
    curl -L -o /usr/local/spark/jars/hadoop-yarn-server-web-proxy-3.3.6.jar https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-yarn-server-web-proxy/3.3.6/hadoop-yarn-server-web-proxy-3.3.6.jar


USER $NB_UID
