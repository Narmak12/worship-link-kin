# Worship Link Kin

Plateforme reliant les talents chrétiens (musiciens, artistes de culte) et les
églises de Kinshasa. Application Flutter + Supabase + Firebase Cloud Messaging.

## Avant de compiler — 2 choses à faire toi-même

1. **Supabase** : ✅ déjà configuré (projet "worship-link-kin", 12 tables + RLS + buckets de stockage créés). Il reste juste à activer un fournisseur SMS (Twilio, MessageBird...) dans Supabase > Authentication > Providers > Phone pour que les vrais SMS de vérification partent — sans ça, la connexion par téléphone ne pourra pas envoyer de code réel.

2. **Firebase (notifications push)** : un `android/app/google-services.json`
   **placeholder** est inclus pour que Gradle ne bloque pas au premier build.
   Remplace-le par ton vrai fichier téléchargé depuis la Firebase Console
   (projet Firebase avec le package `com.worshiplink.kin`) dès que tu veux
   activer les vraies notifications push. Sans ça, l'app fonctionne
   normalement, seules les notifications push resteront inactives.

Tout le reste (icône de l'app, thème de lancement Android, wrapper Gradle,
signature de release) est déjà en place.

## Compiler

```bash
flutter pub get
flutter build apk --release
```

APK généré : `build/app/outputs/flutter-apk/app-release.apk`

Sur Codemagic : connecte le dépôt, choisis `APK` comme artefact dans les
réglages du workflow (section Android), et lance le build.

## Signature de release (optionnel pour tester, requis pour publier)

Un vrai keystore (`worshiplink-release.keystore`) a été généré séparément —
il ne fait PAS partie de ce zip ni du dépôt Git, par sécurité. Pour l'activer :

1. Récupère `worshiplink-release.keystore` et ses mots de passe (fournis à
   part, à conserver précieusement).
2. Place le fichier `.keystore` dans `android/app/`.
3. Copie `android/key.properties.example` en `android/key.properties`
   (même dossier) et remplis-le avec les vrais mots de passe.
4. `android/key.properties` et les fichiers `.keystore` sont déjà exclus par
   `.gitignore` — ne les committe jamais.

Tant que `android/key.properties` n'existe pas, l'APK release se signe
automatiquement avec la clé de debug (utile pour tester, mais pas pour
publier sur le Play Store).

## État du projet

MVP fonctionnel : authentification par OTP téléphone, création de profils
Talent/Église, publication et candidature aux annonces, invitations,
favoris, recherche, calendrier des missions, notifications push,
CGU et politique de confidentialité rédigées.

À vérifier avant publication publique : relecture juridique des CGU/politique
de confidentialité par un professionnel, remplacement de l'icône placeholder
par un vrai design si besoin, tests réels avec de vrais numéros RDC.
