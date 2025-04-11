#!/bin/bash

# Variables personnalisables
CONTAINER_NAME="devops-lab"
IMAGE_NAME="devops-lab_image"

echo "==> 🚀 Déploiement Docker commencé..."

# Étape 1 : Stopper et supprimer l'ancien conteneur
if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
    echo "==> 🛑 Arrêt de l'ancien conteneur..."
    docker stop $CONTAINER_NAME
    docker rm $CONTAINER_NAME
else
    echo "==> Aucun conteneur à arrêter."
fi

# Étape 2 : Supprimer l'image existante (optionnel, si tu veux repartir propre)
if [ "$(docker images -q $IMAGE_NAME)" ]; then
    echo "==> 🧼 Suppression de l'ancienne image..."
    docker rmi $IMAGE_NAME
fi

# Étape 3 : Rebuild de l’image Docker
echo "==> 🔧 Build de la nouvelle image..."
docker build -t $IMAGE_NAME .

# Étape 4 : Lancer le nouveau conteneur
echo "==> 🚀 Lancement du nouveau conteneur..."
docker run -d --name $CONTAINER_NAME -p 80:80 $IMAGE_NAME

echo "==> ✅ Déploiement terminé avec succès."
