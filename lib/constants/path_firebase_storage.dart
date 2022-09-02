class PathFirebaseStorage {
  static String attachments(String? idTransaction) =>
      'attachments/$idTransaction/';
  static String categoryTypes(String? idCategory) =>
      'category_types/$idCategory/';
  static String accountTypes(String? idAccountType) =>
      'account_types/$idAccountType/';
}
