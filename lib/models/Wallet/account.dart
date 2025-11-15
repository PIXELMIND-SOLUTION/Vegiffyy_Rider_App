// lib/models/account.dart
class AccountModel {
  final String id;
  final String accountNumber;
  final String bankName;
  final String accountHolderName;
  final String ifscCode;
  final String? upiId;

  AccountModel({
    required this.id,
    required this.accountNumber,
    required this.bankName,
    required this.accountHolderName,
    required this.ifscCode,
    this.upiId,
  });

  factory AccountModel.fromJson(Map<String, dynamic> j) {
    return AccountModel(
      id: j['_id']?.toString() ?? '',
      accountNumber: j['accountNumber']?.toString() ?? '',
      bankName: j['bankName']?.toString() ?? '',
      accountHolderName: j['accountHolderName']?.toString() ?? '',
      ifscCode: j['ifscCode']?.toString() ?? '',
      upiId: j['upiId']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountNumber': accountNumber,
      'bankName': bankName,
      'accountHolderName': accountHolderName,
      'ifscCode': ifscCode,
      if (upiId != null) 'upiId': upiId,
    };
  }
}
