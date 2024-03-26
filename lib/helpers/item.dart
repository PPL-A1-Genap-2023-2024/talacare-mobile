enum Item {
  // temporary positions, revise after sprites are finished
  mother(30, 30), nurse(30, 70), bed(30, 110), syringe(60, 50), bloodBag(60, 90);
  const Item(this.x, this.y);
  final double x;
  final double y;
}