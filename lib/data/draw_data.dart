class DrawData {
  int _effectCount = 0;

  List<List<(int, int, int)>> allItem = <List<(int, int, int)>>[];

  bool isEffectActive() {
    return _effectCount > 0;
  }

  void addEffectItem(List<(int, int, int)> newItem) {
    _effectCount++;
    allItem.add(newItem);
  }

  void removeEffectItem(List<(int, int, int)> item) {
    _effectCount--;
    allItem.remove(item);
  }

  void initBoard() {}

  void dispose() {}
}
