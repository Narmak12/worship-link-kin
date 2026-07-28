class SupabaseConfig {
  // REMPLACE CES 2 VALEURS par les tiennes (Supabase > Settings > API)
  static const String supabaseUrl = 'https://kuprisokgrtzkgfxpszp.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt1cHJpc29rZ3J0emtnZnhwc3pwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODUyMjAxMjksImV4cCI6MjEwMDc5NjEyOX0.M3uue0TUUUhPz9RrDtd5VCFM5EU3QdS10IaXiZJg0n4';

  static const String profilesTable = 'profiles';
  static const String skillsTable = 'skills';
  static const String jobsTable = 'jobs';
  static const String applicationsTable = 'applications';
  static const String invitationsTable = 'invitations';
  static const String mediaTable = 'media';
  static const String notificationsTable = 'notifications';
  static const String favoritesTable = 'favorites';

  static const String avatarsBucket = 'avatars';
  static const String coversBucket = 'covers';
  static const String portfolioImagesBucket = 'portfolio-images';
  static const String portfolioAudioBucket = 'portfolio-audio';
  static const String portfolioVideosBucket = 'portfolio-videos';
  static const String churchGalleryBucket = 'church-gallery';
}
