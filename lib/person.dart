class Person {
  String personID;
  String name;
  String password;
  String email;
  String addressLine1;
  String addressLine2;
  String neighborhood;
  String city;
  String county;
  String state;
  int zipCode;
  String status;

  Person(
      {
        required this.personID,
        required this.name,
        required this.password,
        required this.email,
        required this.addressLine1,
        required this.addressLine2,
        required this.neighborhood,
        required this.city,
        required this.county,
        required this.state,
        required this.zipCode,
        this.status = "active",
      }
      );

  factory Person.fromJson(Map<String, dynamic> responseData) {
    return Person(
      personID: responseData['personID'],
      name: responseData['name'],
      password: responseData['password'],
      email: responseData['email'],
      addressLine1: responseData['addressLine1'],
      addressLine2: responseData['addressLine2'],
      neighborhood: responseData['neighborhood'],
      city: responseData['city'],
      county: responseData['county'],
      state: responseData['state'],
      zipCode: responseData['zipCode'],
      status: responseData['status'],
    );
  }
}