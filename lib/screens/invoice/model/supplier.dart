import 'dart:io';

class Supplier {
  final File filename;
  final String name;
  final String address;
  final String paymentInfo;
  final String mobileNo;
  final String EmailAddress;

  const Supplier(
      {this.filename,
      this.name,
      this.address,
      this.paymentInfo,
      this.mobileNo,
      this.EmailAddress});
}
