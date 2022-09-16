enum Mode { create, edit, view, approve }

extension modeParseToString on Mode {
  String toStr() {
    return this.toString().split('.').last;
  }
}

enum userRole {
  tenant,
  landlord,
  agent,
  admin,
}

extension userRoleParseToString on userRole {
  String toStr() {
    return this.toString().split('.').last;
  }
}

enum KYCStatus { pending, approved }

extension KYCParseToString on KYCStatus {
  String toStr() {
    return this.toString().split('.').last;
  }
}
