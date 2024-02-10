# Stage 1: Builder
FROM node:20.5.0 as builder

WORKDIR /app

# Copier les fichiers du projet Angular dans l'image
COPY package*.json ./

# Copier le reste des fichiers du projet (à partir de l'emplacement du Dockerfile)
COPY . .

# Installer les dépendances
RUN npm install

# Construire l'application Angular
RUN npm run build

# Stage 2: Final image
#FROM nginx:alpine
#FROM nginx:latest

## Copier le fichier de configuration Nginx personnalisé
COPY nginx.conf /etc/nginx/conf.d/default.conf


# Copier le résultat de la construction dans le répertoire par défaut de Nginx
COPY --from=builder /app/dist/summer-workshop-angular  /usr/share/nginx/html

# Exposer le port 80
EXPOSE 80

# Commande pour exécuter le serveur Nginx
CMD ["nginx", "-g", "daemon off;"]
