class User {
  int _id;
  String _name;
  String _email;
  String _password;
  String _photo;

  User(this._id, this._name, this._email, this._password, this._photo);

  int get id => _id;

  void set id(int id) => _id = id;

  String get name => _name;

  String get email => _email;

  String get password => _password;

  String get photo => _photo;

  // para facilitar o update e insert, vamos usar um Map
  // método para converter User para map
  Map<String, dynamic> toMap() {
    return {
      'name': _name,
      'email': _email,
      'password': _password,
      'photo': _photo,
    };
  }
}