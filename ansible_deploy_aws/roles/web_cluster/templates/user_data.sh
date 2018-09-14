#!/bin/bash

export APP_DATABASE_NAME={{ rds.database_name }}
export APP_DATABASE_USER={{ rds.database_user }}
export APP_DATABASE_PASS={{ rds.database_pass }} 
export APP_DATABASE_HOST={{ rds_intance.instance.endpoint }}
export APP_DATABASE_PORT={{ rds.database_port }}


DIR_PROJECT="/data/http-upload-api"

# generate table
cd ${DIR_PROJECT}/tool/

bash generate_database_table.sh
bash init_web_app.sh start


