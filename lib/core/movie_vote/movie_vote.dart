class MovieVote {
  static String getVoteAverage(num voteAverage) {
    String stringVote = voteAverage.toString();
    if (stringVote.length > 2) {
      return stringVote.substring(0, 3);
    } else {
      return stringVote;
    }
  }
}
