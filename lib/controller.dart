import 'package:groups_v4/utils.dart';

int nrOfChoices = 3;
bool useDefaultCapacity = false;
int defaultCapacity = 15;
bool expandRuleset = false;
bool allowDuplicates = false;
bool allowEmpty = false;
bool allowExcess = false;
bool randomRemaining = false;

Spreadsheet? groupsTable;
Spreadsheet? itemsTable;
Strings groupsErrors = [];
Strings itemsErrors = [];

Groups? groups;
Items? items;

bool readyToStart = false;
