# Studget

Studget dient der Vollkostenberechnung von Studien im Rahmen der EU-Richtlinie für staatliche Beihilfen für Forschung, Entwicklung und Innovation (2014/c 198/01) v. 27.06.20214. Mit der Hilfe von komplexen Vorlagen-mechanismen kann der/die NutzerInnen der Software-Aufwände, die für die Studie benötigt werden, anlegen und berechnen. Gleichzeitig bietet Studget die Möglichkeit schnell und einfach die jeweiligen Kosten transparent wiederzugeben und zu ändern. Kostensätze werden dabei zentral verwaltet und für die verschiedenen Kalkulationstypen bereitgestellt. 

- [Systemanforderungen](#systemanforderungen)
    * [Umgebungseinrichtung](#Umgebungseinrichtung)
    * [Docker installation](#docker-installation)
    * [Lizensierung & Image Download](#lizensierung-und-download-des-docker-images)
    * [Clientseitige Anforderungen](#clientseitige-anforderungen)
- [Erste Schritte](#Erste-Schritte)
- [Umgebungsvariablen](#Umgebungsvariablen)
- [Docker Secrets](#Docker-Secrets)
- [Datenbank Konfiguration](#Initiale-Datenbank-konfiguration)
- [SSL Proxy Server](#ssl-proxy-server)
- [Login](#Standart-Login)
- [Container Shell](#Zugriff-auf-die-Container-Shell)
- [Logs](#anzeige-von-container-logs)

# Systemanforderungen
## Umgebungseinrichtung

Studget ist containerisiert und lässt sich ausschließlich mit einer OCI-kompatiblen Runtime betreiben. Der Betrieb bspw. in Docker ist problemlos möglich und wird aufgrund bisheriger Erfahrungen von Healex empfohlen.  

## Docker installation

Hierfür wird eine Docker Umgebung benötigt (https://www.docker.com/products/container-runtime). 
Mit dieser können die Hosts (unabhängig davon ob real, virtual, lokal oder remote) ausgeführt und angesteuert werden.

Installieren Sie hierfür die Docker Engine: https://docs.docker.com/get-docker/	 

## Lizensierung und Download des Docker Images

Es wird ein Zugang zum privaten Docker Healex Repository benötigt.  
Wenden Sie sich hierfür an <support@healex.systems> um die Lizenzbedingungen zu besprechen. Sobald die Lizenz eingerichtet ist, erhalten Sie ihren Kontonamen, mit welchem der Zugriff zum Docker Repository ermöglicht wird. 

## Hardware-Anforderungen

| Service                    | vCPU    | RAM    | Festplattenspeicher |
|----------------------------|---------|--------|---------------------|
| Studget                    | 2       | 4 GB   | 5 GB                |

Diese Mindestwerte eignen sich für Tests, Prototypen, Pre-PROD und erfahrungsgemäß für den anfänglichen Betrieb der Produktionsumgebung. 
Abhängig von der Entwicklung der realen Nutzung können sich hiervon abweichende Systemanforderungen ergeben. 
Die Hardwareanforderungen sollten vom hauseigenen Betrieb überwacht und angepasst werden. 

## Clientseitige Anforderungen 

  - Keine speziellen Hardwareanforderungen notwendig
  - Aktivierung von JavaScript und Cookies (i.d.R. Browser Standarteinstellungen)
  - Standartkonformer Browser. Aktuelle (nicht älter als 1 Jahr) Versionen des
      * Google Chrome
      * Mozilla Firefox
      * Microsoft Edge

# Erste Schritte 

Am einfachsten lässt sich Studget über `docker compose` starten. Hierfür werden folgende Services benötigt:

  - studget: Applikations Container
  - postgres: PostgreSQL Datenbank Container

Beispiel für eine compose.yml:

```yaml
version: "3.7"

volumes:
   db:
   helparticle:
   config:

services:
  studget:
    image: healexsystems/studget:9.0.2
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
      - config:/app/config    
      - helparticle:/app/Help-Article-Files

  postgres:
    image: postgres:13
    container_name: postgres
    volumes:
      - db:/var/lib/postgresql/data
    environment:
      POSTGRES_USER: studget
      POSTGRES_PASSWORD: password
      POSTGRES_DB: studget
```

# Umgebungsvariablen

Beim starten des Studget Images ist es möglich, die Initialisierung der Studget-Instanz mittels folgender Umgebungsvariablen anzupassen:

| Umgebungsvariable         | Erforderlich | Kommentar/Beschreibung                                                                                                                                    | Standart Wert |  Beispiel                   |
|---------------------------|----------|--------------------------------------------------------------------------------------------------------------------------------------------------------|---------------|------------------------------------|
| `ASPNETCORE_ENVIRONMENT`  | Ja       | Ausführungsumgebung für die ASP.NET Core-Anwendung                                                                                                     | Production    | `Development`                      |
| `VIRTUAL_PORT`            | Ja       | Port auf welchem die Anwendung ausgeführt wird                                                                                                         |      -        | `80`                               |
| `VIRTUAL_HOST`            | Nein     | Domänname, an welche die Anwendung weitergeleitet werden soll                                                                                          |      -        | `my-domain.com`                    |
| `JWT_KEY`                 | Ja       | Key für eine sichere Übertragung von Informationen; (64-Zeichen string)                                                                                |      -        | `58c8317b928b8bdf2a9e45d2c0450e225c56b952a86a6212502714da7f02c2bd`                                 |
| `DB_USER`                 | Ja       | Benutzername, mit dem sich die Anwendung mit der Datenbank verbindet.                                                                                  |      -        | `studget`                          |
| `DB_SSL_MODE`             | Ja       | Verschlüsselte Verbindung zwischen der Anwendung und dem Datenbankserver                                                                               |               | `Disable`                          |
| `DB_NAME`                 | Ja       | Name der Datenbank                                                                                                                                     |      -        | `studget_prd`                      |
| `DB_PORT`                 | Ja       | Port der Datenbank                                                                                                                                     |      -        | `5432`                             |
| `DB_PASSWORD`             | Ja       | Passwort des Datenbank Benutzers                                                                                                                       |      -        | `gdgP23xBLrHKF55Wp7PM`             |
| `DB_HOST`                 | Ja       | Database host name                                                                                                                                     |      -        | `postgres`                         |
| `AES_PASSWORD`            | Ja       | Benutzerdefinierter AES key manager; (32-Zeichen string). Darf nach dem initialen Aufsetzen nicht mehr abgeändert werden                                                                                              |      -        | `34bfddf289ce77c0e1c1ac9769c5202e` |
| `AES_INITIAL_VECTOR`      | Ja       | Initialisierungsvektor welcher gewährleistet, dass identische Klartextblöcke bei wiederholter Verschlüsselung zu unterschiedlichen Chiffretexten führen; (16-Zeichen string). Darf nach dem initialen Aufsetzen nicht mehr abgeändert werden  |      -        | `ece03446c93b4ab7`                 |
| `SMTP_CLIENT_HOST`        | Nein     | SMTP Host Server                                                                                                                                       |      -        | `smtp.office365.com`               |
| `SMTP_CLIENT_PORT`        | Nein     | SMTP Verbindungs Port                                                                                                                                  |      -        | `587`                              |
| `MAIL_ADDRESS`            | Nein     | Adresse welche für den E-Mail versandt verwendet wird                                                                                                  |      -        | `studget@my-domain.com`            |
| `MAIL_ADDRESS_PASSWORD`   | Nein     | Passwort des E-Mail Accounts                                                                                                                           |      -        | `ImportantPassword123`             |
| `JWT_TOKEN_DURATION_HOURS`| Ja       | Zeit nach welcher der JWT Token abläuft                                                                                                                |      -        | `00:30:00`                         |
| `HELP_FILES_BASE_PATH`    | Ja       | Pfad für hochgeladene Dateien                                                                                                                          |      -        | `./Help-Article-Files/`            |
| `VUE_APP_HEALEX_SELF_SERVICE_REGISTER`| Nein  | Redirect URL zum Clinicalsite Register                                                                                                                |      -        | `https://clinicalsite.local/signup`|
| `SELF_SERVICE_DOMAINS`    | Nein     | Erlaubte Domains für den Self-Service                                                                                                                  |      -        | `"['example.de','muster.de']"`     |
| `VUE_APP_CLINICALSITE_URL`| Nein     | Clinicalsite Single Sign-on URL                                                                                                                        |      -        | `https://clinicalsite.local`       |

# Docker Secrets
Als eine alternative zur Weitergabe vertraulicher Informationen über Umgebungsvariablen können Docker-Secrets verwendet werden. Dies zählt für folgende Variablen:

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

# Initiale Datenbank konfiguration

Starte den Datenbank Container und führe das Datenbank Skript aus:

```shell
chmod +x db_setup.sh
./db_setup.sh
```
# SSL Proxy-Server
Eine SSL-Verschlüsselung mittels eines Proxy Servers ist empfohlen und im produktiven Betrieb zwingend.

# Standart Login

Benutzer: Admin <br>
Passwort: 1Admin_User


# Zugriff auf die Container-Shell

Mit dem Befehl `docker exec` können Sie Befehle innerhalb des laufenden Containers ausführen. Mit der folgenden Befehlszeile wird eine Shell im Container geöffnet.

```shell
docker exec -it docker some-studget /bin/sh
```

# Anzeige von Container Logs

```shell
docker logs Container-ID
```
