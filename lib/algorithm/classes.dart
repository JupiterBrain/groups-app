import 'package:groups_v4/utils.dart';

class Group implements Comparable<Group>, CSVSerializable {
  late final int id;
  late final String identifier;
  late final Strings description;
  late final int capacity;
  final Set<Item> members = {};

  Group(this.id, this.identifier, this.description, this.capacity);

  bool get hasSpace => members.length < capacity;
  bool get isFull => members.length >= capacity;
  int get size => members.length;

  bool addMember(Item item) {
    if (isFull) return false;
    return members.add(item);
  }

  bool removeMember(Item item) => members.remove(item);

  @override
  int compareTo(Group other) => id - other.id;

  @override
  String get csv => "$id,$identifier,$size,$capacity";

  @override
  String csvColumns() => "ID,Identifikator,Größe,Kapazität";

  Strings get row => ["$id", identifier, ...description, "$size", "$capacity"];

  @override
  String toString() => csv;
}

class Item implements Comparable<Item>, CSVSerializable {
  late final int id;
  late final Strings description;
  late final Groups choices;
  Group? assignedTo;
  int assignedToIdx = -1;

  Item(this.id, this.description, this.choices);

  bool get isAssigned => assignedTo != null;
  bool get isUnassigned => assignedTo == null;

  bool forceAssign(Group group) {
    if (isAssigned) return false;
    if (!group.addMember(this)) return false;

    assignedTo = group;
    assignedToIdx = -2;
    return true;
  }

  bool assign(int k) {
    if (k < 0 || k >= choices.length) throw "Invalid choice index";
    if (isAssigned) return false;

    var group = choices[k];

    if (!group.addMember(this)) return false;

    assignedTo = group;
    assignedToIdx = k;
    return true;
  }

  bool unassign() {
    if (isUnassigned) return false;

    if (!assignedTo!.removeMember(this)) return false;

    assignedTo = null;
    assignedToIdx = -1;
    return true;
  }

  @override
  int compareTo(Item other) => id - other.id;

  @override
  String get csv => "$id,${description.join(' | ')},${assignedToIdx + 1},"
      "${assignedTo == null ? "null" : assignedTo!.identifier},"
      "${choices.map((e) => e.identifier).join(' | ')}";

  @override
  String csvColumns() => "ID,Beschreibung,k,Gruppe,Wahlen";
  Strings get row => [
        "$id",
        ...description,
        "${assignedToIdx + 1}",
        (assignedTo == null ? "-" : assignedTo!.identifier),
        ...choices.map((e) => e.identifier),
      ];

  @override
  String toString() => csv;
}
