class MotorClassOption {
  final String coverage;
  final bool tor;

  const MotorClassOption({required this.coverage, required this.tor});

  factory MotorClassOption.fromJson(Map<String, dynamic> json) {
    return MotorClassOption(
      coverage: json['coverage']?.toString() ?? '',
      tor: json['tor'] == true,
    );
  }

  Map<String, dynamic> toJson() => {'coverage': coverage, 'tor': tor};
}
