enum SignalZone {
  veryStrong('Sangat Kuat', '< 1 m'),
  strong('Kuat', '1 - 3 m'),
  fair('Cukup', '3 - 10 m'),
  weak('Lemah', '10 - 20 m'),
  veryWeak('Sangat Lemah', '> 20 m'),
  lost('Hilang', 'Di luar jangkauan');

  final String label;
  final String rangeText;
  const SignalZone(this.label, this.rangeText);
}