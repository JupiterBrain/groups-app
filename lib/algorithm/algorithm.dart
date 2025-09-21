import 'package:groups_app/algorithm/classes.dart';
import 'package:groups_app/utils.dart';

Set<Item> performAlgorithm(Items items) {
  Set<Item> unassignable = {};

  for (Item item in items) {
    if (!assignItem(item)) unassignable.add(item);
  }

  return unassignable;
}

bool assignItem(Item item) {
  for (int k = 0; k < item.choices.length; k++) {
    if (item.assign(k) || trySwap(item, k)) return true;
  }

  return false;
}

bool trySwap(Item item, int k) {
  for (int curr = k - 1; curr >= 0; curr--) {
    for (int move = curr + 1; move < k; move++) {
      if (findPartner(item.choices[k], curr, move)) {
        item.assign(k);
        return true;
      }
    }
  }

  return false;
}

bool findPartner(Group choice, int curr, int move) {
  Item partner;
  try {
    partner = choice.members.firstWhere(
      (partner) => (partner.assignedToIdx == curr && canMoveTo(partner, move)),
    );
  } on StateError {
    return false;
  }

  moveTo(partner, move);
  return true;
}

bool canMoveTo(Item item, int k) => item.choices[k].hasSpace;

void moveTo(Item item, int k) {
  item.unassign();
  item.assign(k);
}

/* 
bool trySwap2(Item item, int k) {
  for (int curr = k - 1; curr >= 0; curr--) {
      for (int move = curr + 1; move < k; move++) {
          if (findPartner(item.choices[k], curr, move)) {
              item.assign(k);
              return true;
          }
      }
  }

  return false;
} */

//// Random Remaining

void randomRemaining(Groups groups, Set<Item> unassignable) {
  var vacantGroups = groups.where((g) => g.hasSpace).toSet();

  for (var item in unassignable) {
    if (vacantGroups.isEmpty) return;
    var group = vacantGroups.first;
    item.forceAssign(group);
    if (group.isFull) vacantGroups.remove(group);
  }
}
