# Feuille de route — Worship Link Kin

Ce document sert de référence pour l'évolution du projet, en 4 phases. Aucune
phase n'est activée automatiquement : chaque étape se lance quand la
précédente est stable, sur décision explicite.

---

## Phase 1 — Stabilisation du MVP (EN COURS)

Objectif : une application qui fonctionne de bout en bout, sans bug bloquant,
testable par un utilisateur réel.

- [x] Projet Flutter complet assemblé (écrans, providers, routage)
- [x] Backend Supabase configuré (tables, RLS, buckets de stockage)
- [x] Build Android fonctionnel via Codemagic (APK debug)
- [x] Bug racine de navigation corrigé (recréation du routeur à chaque
      événement d'authentification)
- [x] Mode développement sans SMS (connexion anonyme, bypass Twilio)
- [x] Page Contact avec coordonnées réelles
- [ ] Déconnexion validée sur un build à jour
- [ ] Parcours complet testé : candidature, invitation, création d'annonce,
      profils publics, favoris, notifications
- [ ] Authentification par téléphone réelle (Twilio) activée et testée
- [ ] Icône et texte légal (CGU/confidentialité) finalisés pour publication

**Ne pas passer à la Phase 2 tant que cette liste n'est pas terminée.**

---

## Phase 2 — Réorganisation du dépôt

Objectif : un dépôt lisible et navigable par un humain ou une IA qui découvre
le projet pour la première fois.

- [ ] `README.md` enrichi : présentation, stack, installation, structure des
      dossiers, commandes courantes
- [ ] `ARCHITECTURE.md` : schéma des couches (config/models/providers/
      services/screens/widgets), choix techniques et pourquoi
- [ ] `CHANGELOG.md` : historique des versions (à partir de maintenant,
      pas de reconstruction rétroactive)
- [ ] `CONTRIBUTING.md` : conventions de commit, style de code, process de PR
- [ ] `SECURITY.md` : politique de divulgation, gestion des secrets
- [ ] `docs/` : schéma de base de données, flux d'authentification, décisions
      d'architecture (ADR) pour les choix structurants
- [ ] Nettoyage : suppression des fichiers `.example`/placeholders devenus
      obsolètes, vérification finale du `.gitignore`

---

## Phase 3 — Outillage progressif (CI/CD)

Objectif : automatiser ce qui est aujourd'hui manuel, sans complexifier avant
que ce soit nécessaire.

- [ ] GitHub Actions : `flutter analyze` + `flutter test` automatique sur
      chaque Pull Request (avant tout autre workflow)
- [ ] Secrets CI : migration des identifiants Supabase/Firebase/signature
      vers GitHub Secrets (jamais en clair dans le code)
- [ ] Branche `main` protégée : PR obligatoire, pas de push direct
- [ ] Build Codemagic déclenché automatiquement sur merge dans `main`
      (au lieu du déclenchement manuel actuel)
- [ ] Revue de code automatique basique (lint, formatage) avant revue humaine

**Prérequis** : Phase 1 terminée (sinon la CI ne fait que confirmer des bugs
déjà connus), et un minimum de tests à faire tourner en Phase 2/3.

---

## Phase 4 — Contexte multi-session / multi-agent

Objectif réaliste (voir note ci-dessus sur les limites) : n'importe quelle
session de travail — humaine ou IA — peut reprendre le projet en quelques
minutes, sans dépendre de la mémoire d'une conversation précédente.

- [ ] `prompts/` : contexte de démarrage par domaine (Flutter, Supabase,
      UI/UX, sécurité) — un fichier par domaine, mis à jour au fil de l'eau,
      pas figé à l'avance
- [ ] `TASKS.md` : état d'avancement lisible en un coup d'œil (ce qui est
      fait, en cours, bloqué, et pourquoi)
- [ ] Convention claire de commit/PR pour que l'historique Git raconte
      l'évolution du projet sans avoir à redemander le contexte

**Ce que cette phase ne fait PAS** : un relais automatique entre plusieurs
IA quand un quota est atteint. Ça dépend de systèmes externes que je ne
contrôle pas depuis cette conversation. Ce qui est proposé ici est
l'équivalent pratique atteignable — une documentation assez bonne pour que
la reprise soit rapide, quel que soit qui (ou quoi) reprend le travail.
