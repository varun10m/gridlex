class HealthCareInformation {
  String? firstName;
  String? lastName;
  String? designation;
  String? institutionName;
  String? department;
  String? addressLine1;
  String? addressLine2;
  String? stateName;
  String? cityName;
  String? pinCode;
  String? phoneNumber;
  String? faxNumber;
  String? emailId;
  String? representativeName;
  String? representativeType;
  String? territoryNumber;
  String? countryCode;
  String? telephoneNumber;
  List<String>? product;
  String? requestDescription;
  String? inquiry;
  String? patientName;
  String? dob;
  String? gender;
  String? dateOfRequest;
  List<String>? preferredMethodOfResponse;
  String? url;

  HealthCareInformation(
      {this.firstName,
      this.lastName,
      this.designation,
      this.institutionName,
      this.department,
      this.addressLine1,
      this.addressLine2,
      this.stateName,
      this.cityName,
      this.pinCode,
      this.phoneNumber,
      this.faxNumber,
      this.emailId,
      this.representativeName,
      this.representativeType,
      this.territoryNumber,
      this.countryCode,
      this.telephoneNumber,
      this.product,
      this.requestDescription,
      this.inquiry,
      this.patientName,
      this.dob,
      this.gender,
      this.dateOfRequest,
      this.preferredMethodOfResponse,
      this.url});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> mapToReturn = Map();
    mapToReturn['firstName'] = this.firstName;
    mapToReturn['lastName'] = this.lastName;
    mapToReturn['designation'] = this.designation;
    mapToReturn['institutionName'] = this.institutionName;
    mapToReturn['department'] = this.department;
    mapToReturn['addressLine1'] = this.addressLine1;
    mapToReturn['addressLine2'] = this.addressLine2;
    mapToReturn['state'] = this.stateName;
    mapToReturn['city'] = this.cityName;
    mapToReturn['zip'] = this.pinCode;
    mapToReturn['phoneNumber'] = this.phoneNumber;
    mapToReturn['faxNumber'] = this.faxNumber;
    mapToReturn['email'] = this.emailId;
    mapToReturn['representativeName'] = this.representativeName;
    mapToReturn['representativeType'] = this.representativeType;
    mapToReturn['territoryNumber'] = this.territoryNumber;
    mapToReturn['countryCode'] = this.countryCode;
    mapToReturn['telephoneNumber'] = this.telephoneNumber;
    mapToReturn['product'] = this.product;
    mapToReturn['requestDescription'] = this.requestDescription;
    mapToReturn['inquiry'] = this.inquiry;
    mapToReturn['patientName'] = this.patientName;
    mapToReturn['dob'] = this.dob;
    mapToReturn['gender'] = this.gender;
    mapToReturn['dateOfRequest'] = this.dateOfRequest;
    mapToReturn['preferredMethodOfResponse'] = this.preferredMethodOfResponse;
    mapToReturn["url"] = this.url;
    return mapToReturn;
  }
}
