/// Réglages de développement — à repasser à `false` une fois Twilio/OTP
/// opérationnel et prêt pour la mise en production.
///
/// Quand `kDevMode` est à `true` :
/// - L'écran d'accueil masque le parcours "numéro de téléphone" et ne
///   propose qu'un bouton "Continuer en mode développement" (connexion
///   anonyme Supabase, aucun SMS envoyé).
/// - Le reste de l'application (rôles, profils, annonces, notifications...)
///   fonctionne normalement avec ce compte de test.
const bool kDevMode = true;
