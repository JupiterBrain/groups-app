import 'package:groups_app/utils.dart';

class Group implements Comparable<Group>, CSVSerializable {
  final int id;
  final String identifier;
  final Strings description;
  final int capacity;
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
  final int id;
  final Strings description;
  final Groups choices;
  Group? _assignedTo;
  int _assignedToIdx = -1;

  get assignedToIdx => _assignedToIdx;

  Item(this.id, this.description, this.choices);

  bool get isAssigned => _assignedTo != null;
  bool get isUnassigned => _assignedTo == null;

  bool forceAssign(Group group) {
    if (isAssigned) return false;
    if (!group.addMember(this)) return false;

    _assignedTo = group;
    _assignedToIdx = -2;
    return true;
  }

  bool assign(int k) {
    if (k < 0 || k >= choices.length) throw "Invalid choice index";
    if (isAssigned) return false;

    var group = choices[k];

    if (!group.addMember(this)) return false;

    _assignedTo = group;
    _assignedToIdx = k;
    return true;
  }

  bool unassign() {
    var assignedTo = _assignedTo;

    if (assignedTo == null) return false;

    if (!assignedTo.removeMember(this)) return false;

    _assignedTo = null;
    _assignedToIdx = -1;
    return true;
  }

  @override
  int compareTo(Item other) => id - other.id;

  @override
  String get csv =>
      "$id,${description.join(' | ')},${_assignedToIdx + 1},"
      "${_assignedTo == null ? "null" : _assignedTo!.identifier},"
      "${choices.map((e) => e.identifier).join(' | ')}";

  @override
  String csvColumns() => "ID,Beschreibung,k,Gruppe,Wahlen";
  Strings get row => [
    "$id",
    ...description,
    "${_assignedToIdx + 1}",
    (_assignedTo == null ? "unzugewiesen" : _assignedTo!.identifier),
    ...choices.map((e) => e.identifier),
  ];

  @override
  String toString() => csv;
}
