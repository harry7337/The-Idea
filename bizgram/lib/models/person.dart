abstract class Person {
  final String _name;
  final String _phNo;
  final String _email;
  final String _userName;

  Person(this._name, this._phNo, this._email, this._userName);

  String getName() {
    return this._name;
  }

  String getPhNo() {
    return this._phNo;
  }

  String getEmail() {
    return this._email;
  }

  String getUserName() {
    return this._userName;
  }
}
