class ImageUrl {
  static String getFullUrl(String currentUrl) {
    return "https://image.tmdb.org/t/p/original$currentUrl";
  }
}
