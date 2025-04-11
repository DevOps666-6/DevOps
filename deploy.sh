#!/bin/bash

# === Config ===
CONTAINER_NAME="my-web-app"   # Nom du conteneur
IMAGE_NAME="my-web-app-image" # Nom de l'image Docker
DOCKERFILE="dockerfile-test"  # Nom de ton Dockerfile
PORT_HOST=8081                # Port sur ton serveur (ex: 8080)
PORT_CONTAINER=80             # Port dans le conteneur (ex: 80 pour HTTP)

# === 1. Nettoyage de l'ancien conteneur ===
echo "[1/3] Suppression de l'ancien conteneur..."
if docker inspect $CONTAINER_NAME >/dev/null 2>&1; then
    docker stop $CONTAINER_NAME || echo "⚠️ Échec de l'arrêt, mais on continue..."
    docker rm $CONTAINER_NAME || { echo "❌ Impossible de supprimer le conteneur"; exit 1; }
fi

# === 2. Build de l'image ===
echo "[2/3] Construction de l'image Docker..."
docker build -t $IMAGE_NAME -f $DOCKERFILE . || {
    echo "❌ Échec du build Docker"; exit 1;
}

# === 3. Lancement du nouveau conteneur ===
echo "[3/3] Démarrage du conteneur..."
docker run -d \
    --name $CONTAINER_NAME \
    -p $PORT_HOST:$PORT_CONTAINER \
    $IMAGE_NAME || { echo "❌ Échec du démarrage"; exit 1; }

# === Vérification finale ===
echo "✅ Succès ! Conteneur démarré :"
docker ps --filter "name=$CONTAINER_NAME" --format "table {{.ID}}\t{{.Names}}\t{{.Ports}}"