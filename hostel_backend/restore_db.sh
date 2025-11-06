#/bin/bash

rm -rf db.sqlite3
find . -path "*migrations*" -not -regex ".*__init__.py" -a -not -regex ".*migrations" | xargs rm -rf  
python manage.py makemigrations
python manage.py migrate 
python manage.py loaddata backup.json
