[**Spécifications**](VAR_LINK_REDMINE/wiki) - 
[Environnements](VAR_LINK_REDMINE/wiki/Environnements) - 
[Services](VAR_LINK_REDMINE/wiki/Services) - 
[Documentation](VAR_LINK_REDMINE/wiki/Documentation)

# **Spécifications**

# Contexte

Le site VAR_PROJECT_ID est développée à l'aide du CMS Wordpress

# Architecture

## Plateforme

*   La plateforme reposera sur le CMS Wordpress
*   L'ensemble des données sont stockées en DB MySQL
*   Le back-office permettra de créer des pages à l'aide d'un éditeur visuel

WordPress:

*   Official wordpress core

_Le core de wordpress est installé dans sa dernière version lors de la création du projet.  
Le core doit être maintenu à jour pour garantir une sécurité maximum du site._

Plugins:

*   LINOTYPE
*   Classic Editor
*   Members
*   Post Duplicator
*   Imsanity
*   Intuitive Custom Post Order
*   Scalable Vector Graphics (SVG)
*   Widget Disable
*   Restricted Site Access
*   Cookiebot
*   Polylang Pro
*   Redirection
*   Regenerate Thumbnails
*   The SEO Framework
*   Easy DP SMTP
*   DP Post Ratings

_Toutes les extensions sont installées dans leur dernière version lors de la création du projet.  
Ces extensions doivent être maintenues à jour pour garantir une sécurité maximum du site._  

# Hébergement

## Infrastructure recommandée

### Serveur applicatifs

Les serveurs applicatifs Apache/PHP servent les requêtes HTTP.

*   Cache applicatif
*   Fichiers temporaires lors d'upload de fichier via PHP, par le Backoffice

### Volume de stockage

Le volume est destiné à recevoir tous les assets uploadés via le backoffice : images, svg, PDFs, vidéos, etc.  
La somme des assets devrait être inférieure à 10GB. Pour avoir une marge de sécurité, le volume doit faire 20GB minimum, et peut éventuellement être amené à être augmenté dans le futur.

## Pré-requis techniques

### PHP

*   PHP 7.3
*   Extensions PHP :
    *   locales
    *   wget
    *   git
    *   zip
    *   webp
    *   unzip
    *   curl
    *   libcurl4
    *   libcurl4-gnutls-dev
    *   mariadb-client
    *   libpng-dev
    *   libwebp-dev
    *   libfreetype6-dev
    *   libjpeg62-turbo-dev
    *   libmcrypt-dev
    *   sodium
    *   libsodium-dev
    *   zlib1g-dev
    *   libzip-dev
    *   iconv
    *   pdo
    *   pdo_mysql
    *   mysqli
    *   tokenizer
    *   json
    *   mbstring
    *   gettext
    *   exif
    *   pcntl
    *   intl
    *   gd
*   Librairies spécifiques :
    *   ImageMagick-6.8.9
    *   gd --with-jpeg-dir --with-freetype-dir **--with-webp-dir** --with-png-dir
*   Apache :
    *   a2enmod rewrite
    *   a2enmod proxy
    *   a2enmod headers
    *   a2enmod proxy_http
    *   a2enmod ssl

### MariaDB

Dernière version stable.

### Apache

Dernière version stable

### Apache vhost

```apache
<VirtualHost *:80>

    ServerName exemple.com
    DirectoryIndex index.php
    DocumentRoot /var/www/html

    <Directory /var/www/html>
        Options FollowSymLinks
        AllowOverride All
        Order Allow,Deny
        Allow from All

        <IfModule mod_rewrite.c>
            RewriteEngine On
            RewriteCond %{HTTPS} !=on 
            RewriteRule ^/?(.*) https://%{SERVER_NAME}/$1 [R,L]
        </IfModule>

        <IfModule mod_rewrite.c>
            RewriteEngine On
            RewriteRule ^index\.php$ - [L]
            RewriteCond \$1 ^(index\.php)?$ [OR]
            RewriteCond \$1 \.(gif|jpg|png|ico|css|js)$ [NC,OR]
            RewriteCond %{REQUEST_FILENAME} -f [OR]
            RewriteCond %{REQUEST_FILENAME} -d
            RewriteRule ^(.*)$ - [S=1]
            RewriteRule . /index.php [L]
        </IfModule>

    </Directory>

    ErrorLog /var/log/apache2/app_error.log
    CustomLog /var/log/apache2/app_access.log combined

</VirtualHost>

<VirtualHost *:443>

    ServerName exemple.com
    DirectoryIndex index.php
    DocumentRoot /var/www/html

    <Directory /var/www/html>
        Options FollowSymLinks
        AllowOverride All
        Order Allow,Deny
        Allow from All

        <IfModule mod_rewrite.c>
            RewriteEngine On
            RewriteRule ^index\.php$ - [L]
            RewriteCond \$1 ^(index\.php)?$ [OR]
            RewriteCond \$1 \.(gif|jpg|png|ico|css|js)$ [NC,OR]
            RewriteCond %{REQUEST_FILENAME} -f [OR]
            RewriteCond %{REQUEST_FILENAME} -d
            RewriteRule ^(.*)$ - [S=1]
            RewriteRule . /index.php [L]
        </IfModule>

    </Directory>

    ErrorLog /var/log/apache2/app_error_ssl.log
    CustomLog /var/log/apache2/app_access_ssl.log combined

    SSLEngine on
    SSLCertificateFile /etc/ssl/certs/cert.crt
    SSLCertificateKeyFile /etc/ssl/certs/cert.key

</VirtualHost>
```

# Environements

## Staging

_Hebergement local_

L'environnement de staging est créé et géré par SENSIOGREY et uniquement utilisé pour le développement interne

## Preproduction

_Hebergement simplifié, meme configuration que la production_

L'environnement de préproduction est créé et géré par l'hébergeur et utilisé pour la recette client avant mise en production

## Production

_Hebergement pleine puissance_  

L'environnement de production est créé et géré par l'hébergeur

# Droits

## Gestion des rôles et droits

*   N'importe quel utilisateur peut naviguer sur l'ensemble du site.
*   Le back-office /wp-admin est protégé par IP (whiteliste à fournir en cours de projet)
*   La création d'un utilisateur peut être réalisée uniquement sur le back office.

# Déploiement

Le déploiement est géré depuis l’environnement local via github et Deployer.org  
Deployer permet le déploiement continu et de revenir à une version précédente en cas de problème.  
Ce système fonctionne via ssh, aucun agent ne doit être installé sur le serveur distant.  
Cependant pour autoriser le déploiement, il est nécessaire d’ajouter la clef publique liée au projet sur le serveur distant.