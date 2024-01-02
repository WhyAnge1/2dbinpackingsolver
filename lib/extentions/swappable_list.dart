extension SwappableList<E> on List<E> {
  List<E> swap(int first, int second) {
    if (first >= 0 &&
        second >= 0 &&
        first < this.length &&
        second < this.length) {
      final temp = this[first];
      this[first] = this[second];
      this[second] = temp;
    }

    return this;
  }
}
