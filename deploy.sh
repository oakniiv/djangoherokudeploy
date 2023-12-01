#!/bin/bash

deploy_to_heroku() {
    echo "Deploying to Heroku app: APPNAME..."
    git push heroku main

    echo "Running migrations on Heroku..."
    heroku run python manage.py makemigrations --app APPNAME
    heroku run python manage.py migrate --app APPNAME
}
git add .

if git diff-index --quiet HEAD --; then
    echo "No changes"
else
    # local
    python manage.py makemigrations
    python manage.py migrate

    # Commit changes
    git commit -m "automated runserver commit" #TODO, maybe ask for commit name?
    git push

    # Ask for deployment
    read -p "Do you want to deploy to Heroku? (y/n): " deploy_answer
    if [ "$deploy_answer" == "y" ]; then
        deploy_to_heroku
    else
        echo "Skipping deployment"
    fi
fi

# local
python manage.py makemessages -l de # German translations
python manage.py compilemessages
python manage.py runserver 8000
