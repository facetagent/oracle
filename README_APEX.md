1. Télécharger les 3 composants
Oracle APEX : portail officiel → https://www.oracle.com/tools/downloads/apex-downloads/ — prenez le zip APEX 26.1 (je n'ai pas pu vérifier le nom exact du fichier zip depuis ici, la page bloque les requêtes automatisées, donc prenez celui affiché sur la page)
SQLcl : https://www.oracle.com/database/sqldeveloper/technologies/sqlcl/download/ — prenez SQLcl 26.1
ORDS : https://www.oracle.com/database/technologies/appdev/rest.html — section download, dernière version
2. Installer le schéma APEX dans votre base XE 21c
Décompressez le zip APEX (ex: C:\oracle\apex), puis dans ce dossier :


sqlplus sys/<votre_mdp_sys>@localhost:1521/XEPDB1 as sysdba
Puis dans SQL*Plus :


@apexins.sql SYSAUX SYSAUX TEMP /i/
(SYSAUX = tablespace APEX, SYSAUX = tablespace fichiers, TEMP = temp, /i/ = répertoire virtuel des images)

Ensuite, définir le mot de passe admin APEX :


t 

3. Installer et configurer ORDS
Décompressez ORDS (ex: C:\oracle\ords), ajoutez son dossier bin au PATH, puis :


ords install
Ça lance un assistant interactif : renseignez la connexion DB (localhost:1521/XEPDB1), le mot de passe SYS, et le chemin vers les images APEX (C:\oracle\apex\images).

Démarrer le serveur :


ords serve
L'APEX Builder sera alors accessible sur http://localhost:8080/ords/.

4. Installer SQLcl 26.1
Décompressez (ex: C:\oracle\sqlcl), et mettez son bin AVANT C:\oracle\21c\dbhomeXE\bin dans le PATH (le sql actuel dans dbhomeXE est cassé/obsolète). Vérifiez :


sql -V
5. Créer le workspace + REST-enable le schéma dbapp
Dans le navigateur, http://localhost:8080/ords/ → login INTERNAL avec le mot de passe admin défini à l'étape 2 → créer un workspace pointant sur le schéma dbapp, en cochant "REST Enable Schema" (requis pour l'import APEXlang plus tard).

Ou en ligne de commande SQL, sur le schéma dbapp :


BEGIN
  ORDS.ENABLE_SCHEMA(p_enabled => TRUE, p_schema => 'DBAPP');
END;
/
6. Créer l'app avec le wizard "Create App from Table"
Dans le workspace, App Builder → Create → Create App from Table, sélectionnez CUSTOMER (avant ça, pensez à faire liquibase update pour avoir la colonne phone déjà en place). Ça génère automatiquement la page liste (Interactive Report) + la page formulaire CRUD.

7. Exporter en APEXlang
Dans l'app → Export/Import → Export → format APEXlang. Décompressez le zip obtenu dans ce repo, par exemple sous apex-lang/, et prévenez-moi — je reprendrai la main sur les vrais fichiers .apx pour les ajuster avec vous.