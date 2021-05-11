class AttendanceReportObject{
  int subCode;
  int countOfEmail;
  int totalLength;
  AttendanceReportObject(this.subCode,this.countOfEmail,this.totalLength);
  @override
  String toString() {
    // TODO: implement toString
    return "sub code: $subCode, countOfEmail: $countOfEmail";
  }
}