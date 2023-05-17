class Provider {
  static int reserveIndex(int position, int length) {
    return length >= position
        ? position - 1
        : length > 0
            ? length
            : 0;
  }
}
