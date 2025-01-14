# Studget

Studget dient der Vollkostenberechnung von Studien im Rahmen der EU-Richtlinie für staatliche Beihilfen für Forschung, Entwicklung und Innovation (2014/c 198/01) v. 27.06.20214. Mit der Hilfe von komplexen Vorlagen-Mechanismen können NutzerInnen der Software, Aufwände, die für die Studie benötigt werden, anlegen und berechnen. Gleichzeitig bietet Studget die Möglichkeit, schnell und einfach die jeweiligen Kosten transparent wiederzugeben und zu ändern. Kostensätze werden dabei zentral verwaltet und für die verschiedenen Kalkulationstypen bereitgestellt. 

- [Studget](#studget)
- [Systemanforderungen](#systemanforderungen)
  - [Umgebungseinrichtung](#umgebungseinrichtung)
  - [Docker Installation](#docker-installation)
  - [Lizensierung und Download des Docker Images](#lizensierung-und-download-des-docker-images)
  - [Hardwareanforderungen](#hardwareanforderungen)
  - [Clientseitige Anforderungen](#clientseitige-anforderungen)
- [Erste Schritte](#erste-schritte)
- [Umgebungsvariablen](#umgebungsvariablen)
- [Docker Secrets](#docker-secrets)
- [Flyway](#flyway)
  - [Flyway Konfiguration](#flyway-konfiguration)
  - [Platzhalter](#platzhalter)
  - [Flyway Befehle](#flyway-befehle)
- [OIDC Konfiguration](#oidc-konfiguration)
  - [Einrichten eines OIDC Clients in ClinicalSite](#einrichten-eines-oidc-clients-in-clinicalsite)
  - [Studget Konfiguration](#studget-konfiguration)
  - [Ermitteln der ID einer ClinicalSite Organisations Einheit](#ermitteln-der-id-einer-clinicalsite-organisations-einheit)
  - [Ermitteln der ID einer Studget Organisationseinheit](#ermitteln-der-id-einer-studget-organisationseinheit)
  - [Ermitteln der ID eines Studget Kunden](#ermitteln-der-id-eines-studget-kunden)
- [SSL Proxy-Server](#ssl-proxy-server)
  - [Selbst signierte Zertifikate](#selbst-signierte-zertifikate)
- [Zugriff auf die Container-Shell](#zugriff-auf-die-container-shell)
- [Anzeige von Container Logs](#anzeige-von-container-logs)
- [Studget Upgrade](#studget-upgrade)

# Systemanforderungen
## Umgebungseinrichtung

Studget ist containerisiert und lässt sich ausschließlich mit einer OCI-kompatiblen Runtime betreiben. Der Betrieb, bspw. in Docker, ist problemlos möglich und wird aufgrund bisheriger Erfahrungen von Healex empfohlen.  

## Docker Installation

Hierfür wird eine Docker Umgebung benötigt (https://www.docker.com/products/container-runtime). 
Mit dieser können die Hosts (unabhängig davon, ob real, virtuell, lokal oder remote) ausgeführt und angesteuert werden.

Installieren Sie hierfür die Docker Engine: https://docs.docker.com/get-docker

## Lizensierung und Download des Docker Images

Es wird ein Zugang zum privaten Healex Docker Repository benötigt.  
Wenden Sie sich hierfür an <support@healex.systems> um die Lizenzbedingungen zu besprechen. Sobald die Lizenz eingerichtet ist, erhalten Sie ihren Kontonamen, mit welchem der Zugriff zum Docker Repository ermöglicht wird. 

## Hardwareanforderungen

| Service                    | vCPU    | RAM    | Festplattenspeicher |
|----------------------------|---------|--------|---------------------|
| Studget                    | 2       | 4 GB   | 5 GB                |

Diese Mindestwerte eignen sich für Tests, Prototypen, Pre-PROD und erfahrungsgemäß für den anfänglichen Betrieb der Produktionsumgebung. 
Abhängig von der Entwicklung der realen Nutzung können sich hiervon abweichende Systemanforderungen ergeben. 
Die Hardwareanforderungen sollten vom hauseigenen Betrieb überwacht und angepasst werden.

## Clientseitige Anforderungen 

  - Keine speziellen Hardwareanforderungen notwendig
  - Aktivierung von JavaScript und Cookies (i.d.R. Browser Standardeinstellungen)
  - Standardkonformer Browser: aktuelle Versionen (nicht älter als 1 Jahr) des
      * Google Chrome
      * Mozilla Firefox
      * Microsoft Edge
      * Safari

# Erste Schritte 

Am einfachsten lässt sich Studget über `docker compose` starten. Hierfür werden folgende Services benötigt:

  - studget: Applikations-Container
  - postgres: PostgreSQL Datenbank Container

Beispiel für eine compose.yml:

```yaml
version: "3.7"

volumes:
   db:
   helparticle:

services:
  studget:
    image: healexsystems/studget:11.3.5
    container_name: studget
    environment:
      ASPNETCORE_ENVIRONMENT: Staging
      DB_SSL_MODE: Disable
      DB_USER: studget
      DB_NAME: studget
      DB_HOST: postgres
      JWT_TOKEN_DURATION_HOURS: 03:00:00
      JWT_KEY: 64-character-string
      AES_INITIAL_VECTOR: 16-character-string
      AES_PASSWORD: 32-character-string
      DB_PASSWORD: password
      DB_PORT: 5432
      HELP_FILES_BASE_PATH: ./Help-Article-Files/
    ports:
      - 8080:80
    volumes:
      #- ./config:/app/config    # Nur für OIDC
      - helparticle:/app/Help-Article-Files

  postgres:
    image: postgres:15-alpine
    container_name: postgres
    volumes:
      - db:/var/lib/postgresql/data
    environment:
      POSTGRES_USER: studget
      POSTGRES_PASSWORD: password
      POSTGRES_DB: studget

  flyway:
    image: flyway/flyway:10-alpine
    container_name: flyway
    environment:
      FLYWAY_USER: studget
      FLYWAY_PASSWORD: password
      FLYWAY_URL: jdbc:postgresql://postgres:5432/studget
      FLYWAY_SCHEMAS: public
    command: [
      "-locations=filesystem:/flyway/sql",
      "-connectRetries=60",
      "-placeholders.studgetAdminUserName=admin",
      "-placeholders.studgetAdminName=admin",
      "-placeholders.studgetAdminMail=studget@my-domain.com",
      "-placeholders.studgetAdminPassword=Studget2024#",
      "-placeholders.dataBaseUser=studget",
      "-placeholders.dataBasePassword=password",
      "-placeholders.postgresDataBaseUser=studget",
      "-placeholders.postgresDataBasePassword=password",
      "-placeholders.aesInitialVector=16-character-string",
      "-placeholders.aesPassword=32-character-string",
      "info",
      "migrate",
      "info"
    ]
    volumes:
      - ./flyway/:/flyway/sql

```

# Umgebungsvariablen

Beim Starten des Studget-Images ist es möglich, die Initialisierung der Studget-Instanz mittels folgender Umgebungsvariablen anzupassen:

| Umgebungsvariable         | Erforderlich | Kommentar/Beschreibung                                                                                                                                    | Standard Wert |  Beispiel                   |
|---------------------------|----------|--------------------------------------------------------------------------------------------------------------------------------------------------------|---------------|------------------------------------|
| `ASPNETCORE_ENVIRONMENT`  | Ja       | Ausführungsumgebung für die ASP.NET Core-Anwendung                                                                                                     | Production    | `Development`                      |
| `VIRTUAL_PORT`            | Ja       | Port auf welchem die Anwendung ausgeführt wird                                                                                                         |      -        | `80`                               |
| `VIRTUAL_HOST`            | Nein     | Domainname, an welche die Anwendung weitergeleitet werden soll                                                                                          |      -        | `my-domain.com`                    |
| `JWT_KEY`                 | Ja       | Key für eine sichere Übertragung von Informationen; (64-Zeichen string)                                                                                |      -        | `58c8317b928b8bdf2a9e45d2c0450e225c56b952a86a6212502714da7f02c2bd`                                 |
| `DB_USER`                 | Ja       | Benutzername, mit dem sich die Anwendung mit der Datenbank verbindet.                                                                                  |      -        | `studget`                          |
| `DB_SSL_MODE`             | Ja       | Verschlüsselte Verbindung zwischen der Anwendung und dem Datenbankserver                                                                               |               | `Disable`                          |
| `DB_NAME`                 | Ja       | Name der Datenbank                                                                                                                                     |      -        | `studget_prd`                      |
| `DB_PORT`                 | Ja       | Port der Datenbank                                                                                                                                     |      -        | `5432`                             |
| `DB_PASSWORD`             | Ja       | Passwort des Datenbank-Benutzers                                                                                                                       |      -        | `gdgP23xBLrHKF55Wp7PM`             |
| `DB_HOST`                 | Ja       | Database host name                                                                                                                                     |      -        | `postgres`                         |
| `AES_PASSWORD`            | Ja       | Benutzerdefinierter AES key manager; (32-Zeichen string). Darf nach dem initialen Aufsetzen nicht mehr abgeändert werden                                                                                              |      -        | `34bfddf289ce77c0e1c1ac9769c5202e` |
| `AES_INITIAL_VECTOR`      | Ja       | Initialisierungsvektor, welcher gewährleistet, dass identische Klartextblöcke bei wiederholter Verschlüsselung zu unterschiedlichen Chiffretexten führen; (16-Zeichen string). Darf nach dem initialen Aufsetzen nicht mehr abgeändert werden  |      -        | `ece03446c93b4ab7`                 |
| `SMTP_CLIENT_HOST`        | Nein     | SMTP Host Server                                                                                                                                       |      -        | `smtp.office365.com`               |
| `SMTP_CLIENT_PORT`        | Nein     | SMTP Verbindungsport                                                                                                                                  |      -        | `587`                              |
| `MAIL_ADDRESS_LOGIN`      | Nein     | Login-Adresse für die E-Mail Server authentifizierung                                                                                                |      -        | `studget@my-domain.com`            |
| `MAIL_ADDRESS_SENDER`     | Nein     | Absenderadresse, welche für den E-Mail-Versand verwendet wird                                                                                        |      -        | `studget@my-domain.com`            |
| `MAIL_ADDRESS_LOGIN_PASSWORD`   | Nein     | Login-Passwort für die E-Mail Server authentifizierung                                                                                           |      -        | `ImportantPassword123`             |
| `MAIL_ADDRESS_SENDER_PASSWORD`  | Nein     | Sender-Passwort für die E-Mail Server authentifizierung                                                                                          |      -        | `ImportantPassword123`             |
| `JWT_TOKEN_DURATION_HOURS`| Ja       | Zeit, nach welcher der JWT Token abläuft                                                                                                                |      -        | `00:30:00`                         |
| `HELP_FILES_BASE_PATH`    | Ja       | Pfad für hochgeladene Dateien                                                                                                                          |      -        | `./Help-Article-Files/`            |
| `VUE_APP_HEALEX_SELF_SERVICE_REGISTER`| Nein  | Redirect URL zum Clinicalsite Register                                                                                                                |      -        | `https://clinicalsite.local/signup`|
| `SELF_SERVICE_DOMAINS`    | Nein     | Erlaubte Domains für den Self-Service                                                                                                                  |      -        | `"['example.de','muster.de']"`     |
| `VUE_APP_CLINICALSITE_URL`| Nein     | Clinicalsite Single Sign-on URL                                                                                                                        |      -        | `https://clinicalsite.local`       |
| `VUE_APP_CLIENT_ID`       | Nein     | Clinicalsite external Cliend ID                                                                                                                      |      -        | `studget`       |

# Docker Secrets
Als eine Alternative zur Weitergabe vertraulicher Informationen über Umgebungsvariablen können Docker-Secrets verwendet werden. Dies zählt für folgende Variablen:

- JWT_KEY
- SMTP_CLIENT_PORT
- MAIL_ADDRESS_PASSWORD
- AES_INITIAL_VECTOR
- AES_PASSWORD
- DB_PASSWORD
- DB_PORT

Zum Beispiel:

```yaml
version: "3.7"

secrets:
  jwt_key:
    file: ./secrets/jwt_key_file

services:
  studget:
    image: healexsystems/studget:latest
    environment:
      ASPNETCORE_ENVIRONMENT: Staging
      DB_SSL_MODE: Disable
      DB_USER: studget
      DB_NAME: studget
      DB_HOST: postgres
      JWT_TOKEN_DURATION_HOURS: 03:00:00
      AES_INITIAL_VECTOR: 16-character-string
      AES_PASSWORD: 32-character-string
      DB_PASSWORD: password
      DB_PORT: 5432
      HELP_FILES_BASE_PATH: ./Help-Article-Files/
    secrets:
      - source: jwt_key_file
        target: JWT_KEY
```

# Flyway

Der Zweck des Flyway Containers liegt darin, die initiale Datenbank aufzusetzen sowie Datenbankmigrationen bei Upgrades durchzuführen.

## Flyway Konfiguration

```yaml
flyway:
    container_name: flyway
    image: flyway/flyway:10-alpine
    environment:
      FLYWAY_USER: ${pg_db_user}
      FLYWAY_PASSWORD: ${pg_db_password}
      FLYWAY_URL: jdbc:postgresql://${pg_db_host}:5432/${pg_db_user}
      FLYWAY_SCHEMAS: public
    command:
      - "-locations=filesystem:/flyway/sql"
      - "-connectRetries=60"
      - "-placeholders.studgetAdminUserName=${studget_admin_user_name}"
      - "-placeholders.studgetAdminName=${studget_admin_name}"
      - "-placeholders.studgetAdminMail=${studget_admin_mail}"
      - "-placeholders.studgetAdminPassword=${studget_admin_password}"
      - "-placeholders.dataBaseUser=${backend_db_user}"
      - "-placeholders.dataBasePassword=${backend_db_password}"
      - "-placeholders.postgresDataBaseUser=${pg_db_user}"
      - "-placeholders.postgresDataBasePassword=${pg_db_password}"
      - "-placeholders.aesInitialVector=${aes_initial_vector}"
      - "-placeholders.aesPassword=${aes_password}"
      - "info"
      - "migrate"
      - "info"
    volumes:
      - ./database/flyway/sql:/flyway/sql
```
  
## Platzhalter

Platzhalter in Flyway werden dazu verwendet, um Werte in den SQL-Migrationsskripten dynamisch zu ersetzen.

Die folgenden Platzhalter werden zum Einrichten des ersten Studget-Administratorbenutzers verwendet:

- `studgetAdminUserName`: Benutzername für den Studget-Administratorbenutzer.
- `studgetAdminName`: Name des Studget-Administratorbenutzers.
- `studgetAdminMail`: E-Mail-Adresse des Studget-Administratorbenutzers.
- `studgetAdminPassword`: Passwort für den Studget-Administratorbenutzer.

Die folgenden Platzhalter werden verwendet, um das verschlüsselte Passwort mithilfe von AES-Werten einzurichten.

- `aesInitialVector`: AES-Anfangsvektor für die Verschlüsselung.
- `aesPassword`: AES-Schlüssel zur Verschlüsselung.

Für die Datenbank Backend-Anmeldung werden folgende Platzhalter verwendet:

- `dataBaseUser`: Datenbank-Backend-Benutzer.
- `dataBasePassword`: Passwort des Datenbank-Backend-Benutzers.

Für die Datenbank Anmeldung werden folgende Platzhalter verwendet:

- `postgresDataBaseUser`: Datenbank-Benutzer.
- `postgresDataBasePassword`: Passwort des Datenbank-Benutzers.

## Flyway Befehle

Flyway unterstützt eine Vielzahl von Befehlen zum Verwalten von Datenbankmigrationen. Im Studget Kontext werden die folgenden Befehle verwendet:

- `info`: Zeigt den aktuellen Status von allen Migrationen an.
- `migrate`: Alle ausstehenden Migrationen werden angewendet.

Weitere Informationen zu Flyway können [hier](https://github.com/flyway/flyway-docker) entnommen werden.

# OIDC Konfiguration

## Einrichten eines OIDC Clients in ClinicalSite

Hierfür werden administrative Rechte in ClinicalSite benötigt. Navigieren Sie zu: <br> 
* ` Verwaltung - Externe Systeme`
* Erstellen Sie ein `Neues externes System`
* Wählen Sie eine beliebige Bezeichnung für den Client im Feld `Name`
* Wählen Sie einen Namen für den `Bezeichner (Client ID)`
* Wählen Sie Client-Typ: `Browser-basiert (Authentifizierung ohne Kennwort, PKCE-Unterstützung erforderlich)`
* Tragen Sie folgende `Redirect-URLs` ein, z.B.:
  * https://studget.example.com/UserProfile
  * https://studget.example.com/login/callback
* Fügen Sie die Organisationseinheiten unter `Relevante Org.-Einheite` hinzu, welche in den Studget-Konfigurationsdateien aufgeführt sind. Um sich erfolgreich einloggen zu können, müssen Personen Affiliierte von mindestens einer zugangs-gewährender und einer gemappten Organisations-Einheit sein, siehe unten.
* Legen Sie den Client an

## Studget Konfiguration

Um Studget via OIDC mit ClinicalSite zu verbinden, müssen folgende Umgebungsvariablen im Studget Service gesetzt werden:

* `VUE_APP_CLINICALSITE_URL`
* `VUE_APP_CLIENT_ID`

Erstellen Sie einen neuen Ordner beispielsweise mit den Namen "config" und mappen diesen zum Pfad: `/app/config` innerhalb des Containers vom Studget Service.
Folgende Dateien müssen innerhalb des neuen Ordners angelegt werden:
* `clinicalsite_access_required_orgunits.json`
* `clinicalsite_orgunits_whitelist.json`
* `clinicalsite_customer_ids.json`
* `clinicalsite_orgunits_link.json`

-------------------------------------------------------------------------------------------------
 `clinicalsite_access_required_orgunits.json` <br>
Enthält eine Auflistung von ClinicalSite Organisations IDs, welche für den Login berechtigt werden. Wenn der Benutzer nicht mit einer Organisations-Einheit aus der Liste affiliiert ist, werden alle Berechtigungen des ClinicalSite-Benutzers widerrufen. <br> 

Beispielsweise:
```json
[1,24,3]
```
-------------------------------------------------------------------------------------------------
`clinicalsite_orgunits_whitelist.json` <br>
Enthält eine Auflistung von ClinicalSite Organisations IDs, welche für ein Mapping zwischen dem ClinicalSite und Studget berücksichtigt werden sollen. <br>

Beispielsweise:
```json
[1,24,3]
```
-------------------------------------------------------------------------------------------------
`clinicalsite_customer_ids.json` <br>
In dieser Datei wird die Verknüpfung von der ClinicalSite Organisationseinheit mit der Studget Kunden-ID gesetzt. <br>

Im folgenden Beispiel werden Affiliierte der ClinicalSite Organisationseinheit mit der ID:1 in den Studget Kunden mit der ID:1 und Affiliierte der ClinicalSite Organisationseinheit mit der ID:2 in den Studget Kunden mit der ID:12 gemappt.

```json
[
    {
      "StudgetID": "1",
      "ClinicalSiteID": "1"
    },
    {
      "StudgetID": "2",
      "ClinicalSiteID": "12"
    }    
] 
```

Information: 
* Ein ClinicalSite Nutzer kann nur in einen Studget Kunden gemappt werden, darum müssen alle Organisationseinheiten aus einem ClinicalSite Tenant in den gleichen Studget Kunden gemappt werden.
-------------------------------------------------------------------------------------------------
`clinicalsite_orgunits_link.json` <br>
In dieser Datei wird die Verknüpfung von der ClinicalSite Organisationseinheit mit der Studget Organisationseinheit gesetzt. <br>

Im folgenden Beispiel haben Affiliierte der ClinicalSite Organisationseinheit mit der ID:1 Zugriff auf die Studget Organisationseinheit mit der ID:1 und Affiliierte der ClinicalSite Organisationseinheit mit der ID:2 Zugriff auf die Studget Organisationseinheit mit der ID:12
```json
[
    {
      "StudgetID": "1",
      "ClinicalSiteID": "1"
    },
    {
      "StudgetID": "2",
      "ClinicalSiteID": "12"
    }    
] 
```

Information: 
* Um sich erfolgreich einloggen zu können, muss die Studget Organisationseinheit Mitglied des Studget Kunden sein.
* Es ist möglich mehrere ClinicalSite Organisationseinheiten auf eine Studget Organisationseinheit zu mappen. Allerdings darf der ClinicalSite Benutzer nur mit einer ClinicalSite Organisationseinheit affiliert sein.

-------------------------------------------------------------------------------------------------
## Ermitteln der ID einer ClinicalSite Organisations Einheit
Klicken Sie auf die Organisationseinheit in ClinicalSite. Die ID ist der Browser-URL zu entnehmen. <br>
Beispiel: https://clinicalsite.example.com/ou/`${ID}`

## Ermitteln der ID einer Studget Organisationseinheit
Als Benutzer mit administrativen Rechten navigieren Sie zu: <br> 
`Einstellungen - Organisationseinheiten` 

Hier kann die ID des jeweiligen Mandanten entnommen werden.

## Ermitteln der ID eines Studget Kunden
Als administrator einer Studget Organisationseinheit navigieren Sie zu: <br>
`Einstellungen - Kunden`

Hier kann die ID des jeweiligen Kunden entnommen werden.

# SSL Proxy-Server
Eine SSL-Verschlüsselung mittels eines Proxy Servers ist empfohlen und im produktiven Betrieb zwingend.

## Selbst signierte Zertifikate
Für den Fall, dass Studget mit Servern kommuniziert, welche selbst signierte Zertifikate verwenden, muss das Root Zertifikat der eigenen Zertifizierungsstelle auf Betriebssystemebene dem Studget Docker Image hinzugefügt werden.
Dies ist beispielsweise der Fall, wenn Studget via OIDC mit ClinicalSite angebunden wird und ClinicalSite selbst signierte Zertifikate verwendet.

In dem folgenden Beispiel wird das Root Zertifikat dem Studget Image mit der Version 11.3.5 mittels eines Dockerfiles hinzugefügt:

```shell
FROM healexsystems/studget:11.3.5

USER root

# To be able to download `ca-certificates` with `apk add` command
COPY rootCA.crt /root/my-root-ca.crt
RUN cat /root/my-root-ca.crt >> /etc/ssl/certs/ca-certificates.crt

# Add again root CA with `update-ca-certificates` tool
RUN apk --no-cache add ca-certificates \
    && rm -rf /var/cache/apk/*
COPY rootCA.crt /usr/local/share/ca-certificates
RUN update-ca-certificates
```

# Zugriff auf die Container-Shell
Mit dem Befehl `docker exec` können Befehle innerhalb des laufenden Containers ausgeführt werden. Mit der folgenden Befehlszeile wird eine Container-Shell geöffnet.

```shell
docker exec -it docker some-studget /bin/sh
```

# Anzeige von Container Logs
```shell
docker logs Container-ID
```
# Studget Upgrade

1. Laden Sie das Image herunter, auf welches geupgraded werden soll, beispielsweise für die Version `10.2.0`: <br> 
```shell
docker pull healexsystems/studget:10.2.0
```
2. Aktualisierung der Datenbank Migrationen: Im Flyway-Ordner müssen die für die jeweilige Version benötigten Migrationen enthalten sein. Wird beispielsweise von Version `10.1.0` auf die Version `10.2.0` geupgraded (die Version `10.1.1` wird übersprungen), beinhaltet der Migrationsname der letzten auszuführenden Migration: `Changelog_10.2.0`. Befinden sich Migrationen bereits im Flyway-Ordner, bleiben diese bestehen und sollten nicht gelöscht werden.

In dem genannten Beispiel beinhaltet der Flyway-Ordner von Version `10.1.0` folgende Dateien:
```shell
V1_0_0__Initial_database.sql
V15_0_3__Create_example_colum.sql
V15_0_4__Changelog_10.1.0.sql
```
----
Für das Upgrade auf die Version `10.2.0` werden folgende Migrations-Dateien hinzugefügt:
```shell
V15_0_5___Add_some_features.sql
V15_0_6__Changelog_10.1.1.sql
V15_0_7__Changelog_10.2.0.sql
```
----
Dementsprechend beinhalt der Flyway-Ordner der Version `10.2.0` folgende Dateien:
```shell
V1_0_0__Initial_database.sql
V15_0_3__Create_example_colum.sql
V15_0_4__Changelog_10.1.0.sql
V15_0_5___Add_some_features.sql
V15_0_6__Changelog_10.1.1.sql
V15_0_7__Changelog_10.2.0.sql
```
3. Neustart des Docker Stacks.