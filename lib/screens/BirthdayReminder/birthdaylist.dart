import 'models/notes.dart';

class BirthdayListVar {
  static final BirthdayListVar _instance = BirthdayListVar._internal();
  factory BirthdayListVar() => _instance;
  BirthdayListVar._internal();

  List<Notes> list = [];
}
