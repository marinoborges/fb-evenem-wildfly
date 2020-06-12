FROM jboss/wildfly:9.0.2.Final

ENV JBOSS_HOME /opt/jboss/wildfly

ARG DB_HOST=fb-evenem-postgresql.host
ARG DB_NAME=bradesco_enem3
ARG DB_USER=postgres
ARG DB_PASS=zZ0kKDEEUQnY
ARG POSTGRES_JDBC=postgresql-42.2.13.jar
ARG JVM_XMX=2048m
ARG LIB_PATH=/opt/lib/

USER root

# Deploy postgres jdbc, jackson and datasources
ADD $POSTGRES_JDBC $LIB_PATH
ADD jackson.zip $LIB_PATH

RUN	cd $JBOSS_HOME && unzip -o $LIB_PATH/jackson.zip &&\
	sed -i "s/Xmx512m/Xmx${JVM_XMX}/" $JBOSS_HOME/bin/standalone.conf &&\
	/bin/sh -c '$JBOSS_HOME/bin/standalone.sh &' && \
	sleep 10 && \
	$JBOSS_HOME/bin/jboss-cli.sh -c --command="deploy $LIB_PATH/$POSTGRES_JDBC" &&\
	$JBOSS_HOME/bin/jboss-cli.sh -c --command="xa-data-source add --name=VarejoDS --jndi-name=java:jboss/VarejoDS --user-name=${DB_USER} --password=${DB_PASS} --min-pool-size=2 --max-pool-size=10 --driver-name=postgresql-42.2.13.jar --xa-datasource-class=org.postgresql.xa.PGXADataSource --xa-datasource-properties=ServerName=${DB_HOST},PortNumber=5432,DatabaseName=${DB_NAME} --valid-connection-checker-class-name=org.jboss.jca.adapters.jdbc.extensions.postgres.PostgreSQLValidConnectionChecker --exception-sorter-class-name=org.jboss.jca.adapters.jdbc.extensions.postgres.PostgreSQLExceptionSorter" &&\
	$JBOSS_HOME/bin/jboss-cli.sh -c --command="xa-data-source add --name=UniversiaDS --jndi-name=java:jboss/UniversiaDS --user-name=${DB_USER} --password=${DB_PASS} --min-pool-size=2 --max-pool-size=60 --driver-name=postgresql-42.2.13.jar --xa-datasource-class=org.postgresql.xa.PGXADataSource --xa-datasource-properties=ServerName=${DB_HOST},PortNumber=5432,DatabaseName=${DB_NAME} --valid-connection-checker-class-name=org.jboss.jca.adapters.jdbc.extensions.postgres.PostgreSQLValidConnectionChecker --exception-sorter-class-name=org.jboss.jca.adapters.jdbc.extensions.postgres.PostgreSQLExceptionSorter" &&\
	$JBOSS_HOME/bin/jboss-cli.sh -c --command="xa-data-source add --name=UniessaEnemDS --jndi-name=java:jboss/UniessaEnemDS --user-name=${DB_USER} --password=${DB_PASS} --min-pool-size=2 --max-pool-size=4 --driver-name=postgresql-42.2.13.jar --xa-datasource-class=org.postgresql.xa.PGXADataSource --xa-datasource-properties=ServerName=${DB_HOST},PortNumber=5432,DatabaseName=${DB_NAME} --valid-connection-checker-class-name=org.jboss.jca.adapters.jdbc.extensions.postgres.PostgreSQLValidConnectionChecker --exception-sorter-class-name=org.jboss.jca.adapters.jdbc.extensions.postgres.PostgreSQLExceptionSorter" &&\
	$JBOSS_HOME/bin/jboss-cli.sh -c --command="xa-data-source add --name=BaseNoviDS --jndi-name=java:jboss/BaseNoviDS --user-name=${DB_USER} --password=${DB_PASS} --min-pool-size=5 --max-pool-size=10 --driver-name=postgresql-42.2.13.jar --xa-datasource-class=org.postgresql.xa.PGXADataSource --xa-datasource-properties=ServerName=${DB_HOST},PortNumber=5432,DatabaseName=${DB_NAME} --valid-connection-checker-class-name=org.jboss.jca.adapters.jdbc.extensions.postgres.PostgreSQLValidConnectionChecker --exception-sorter-class-name=org.jboss.jca.adapters.jdbc.extensions.postgres.PostgreSQLExceptionSorter" &&\
	rm -rf $JBOSS_HOME/standalone/configuration/standalone_xml_history/ $JBOSS_HOME/standalone/log/*

# Deploy enem.war
ADD enem.war $JBOSS_HOME/standalone/deployments/

EXPOSE 8080

#CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]
CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0"]
