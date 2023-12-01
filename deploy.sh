#!/bin/bash

# Function to deploy to Heroku
deploy_to_heroku() {
    echo "Running Django migrations..."
    python manage.py makemigrations
    python manage.py migrate

    echo "Deploying to Heroku app: APPNAME..."
    git push heroku main
}

# Add all changes to git
git add .

# Check if there are any changes
if git diff-index --quiet HEAD --; then
    echo "No changes"
else
    # Commit changes
    git commit -m "automated runserver commit" #TODO, maybe ask for commit name?

    # Ask for deployment
    read -p "Do you want to deploy to Heroku? (y/n): " deploy_answer
    if [ "$deploy_answer" == "y" ]; then
        deploy_to_heroku
    else
        echo "Skipping deployment"
    fi
fi

# run local
python manage.py makemigrations
python manage.py migrate
python manage.py makemessages -l de # German translations
python manage.py compilemessages
python manage.py runserver 8000
