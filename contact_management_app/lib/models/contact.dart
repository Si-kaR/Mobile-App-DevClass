class Contact {
  final int pid;
  final String pname;
  final String pphone;

  Contact({
    required this.pid,
    required this.pname,
    required this.pphone,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      pid: json['pid'],
      pname: json['pname'],
      pphone: json['pphone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pid': pid,
      'pname': pname,
      'pphone': pphone,
    };
  }
}
