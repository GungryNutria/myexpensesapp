class Errordetails {
  String? message;
  String? error;
  int? statusCode;
  Errordetails({this.message, this.error, this.statusCode});

  factory Errordetails.fromJson(Map<String, dynamic> json){
    return Errordetails(message: json['message'], error: json['error'], statusCode: json['statusCode']);
  }
}