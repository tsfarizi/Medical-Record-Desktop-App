class SettingsState {
  final bool isDatabaseOn;
  final String serverId;
  final String ipAddress;

  SettingsState({
    required this.isDatabaseOn,
    required this.serverId,
    required this.ipAddress,
  });

  factory SettingsState.initial() {
    return SettingsState(
      isDatabaseOn: false,
      serverId: '',
      ipAddress: '',
    );
  }

  SettingsState copyWith({
    bool? isDatabaseOn,
    String? serverId,
    String? ipAddress,
  }) {
    return SettingsState(
      isDatabaseOn: isDatabaseOn ?? this.isDatabaseOn,
      serverId: serverId ?? this.serverId,
      ipAddress: ipAddress ?? this.ipAddress,
    );
  }
}
