import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medgis_app/view/settings/bloc/settings_state.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsCubit extends Cubit<SettingsState> {
  Process? _pocketBaseProcess;
  final NetworkInfo _networkInfo = NetworkInfo();

  SettingsCubit() : super(SettingsState.initial()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final isDatabaseOn = prefs.getBool('isDatabaseOn') ?? false;
    final serverId = prefs.getString('serverId') ?? '';
    final ipAddress = prefs.getString('ipAddress') ?? '';

    if (isDatabaseOn && ipAddress.isNotEmpty) {
      try {
        _startPocketBase(ipAddress);
      } catch (e) {
        emit(state.copyWith(
          isDatabaseOn: false,
          serverId: '',
          ipAddress: '',
        ));
        return;
      }
    }

    emit(state.copyWith(
      isDatabaseOn: isDatabaseOn,
      serverId: serverId,
      ipAddress: ipAddress,
    ));
  }

  Future<void> toggleDatabase(bool value) async {
    if (value) {
      try {
        final ipAddress = await _networkInfo.getWifiIP();
        if (ipAddress == null) throw Exception('Unable to get IP Address');

        final segments = ipAddress.split('.');
        if (segments.length < 4) throw Exception('Invalid IP Address');

        final serverId = '${segments[2]}.${segments[3]}';
        final baseUrl = '$ipAddress:2003';
        const pocketBasePath =
            '.\\pocketbase_0.22.20_windows_amd64\\pocketbase.exe';

        _pocketBaseProcess = await Process.start(
          pocketBasePath,
          ['serve', '--http=$baseUrl'],
          runInShell: true,
        );

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isDatabaseOn', true);
        await prefs.setString('serverId', serverId);
        await prefs.setString('ipAddress', ipAddress);

        emit(state.copyWith(
          isDatabaseOn: true,
          serverId: serverId,
          ipAddress: ipAddress,
        ));
      } catch (e) {
        emit(state.copyWith(
          isDatabaseOn: false,
          serverId: '',
          ipAddress: '',
        ));
      }
    } else {
      if (_pocketBaseProcess != null) {
        _pocketBaseProcess!.kill();
        _pocketBaseProcess = null;
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDatabaseOn', false);
      await prefs.setString('serverId', '');
      await prefs.setString('ipAddress', '');

      emit(state.copyWith(
        isDatabaseOn: false,
        serverId: '',
        ipAddress: '',
      ));
    }
  }

  Future<void> connectWithServerId(String serverIdInput) async {
    try {
      final currentIp = await _networkInfo.getWifiIP();
      if (currentIp == null) throw Exception('Unable to get current IP');

      final segments = currentIp.split('.');
      if (segments.length < 4) throw Exception('Invalid current IP');

      final serverSegments = serverIdInput.split('.');
      if (serverSegments.length != 2) throw Exception('Invalid Server ID');

      final newSegments = [...segments];
      newSegments[2] = serverSegments[0];
      newSegments[3] = serverSegments[1];
      final newIpAddress = newSegments.join('.');

      final baseUrl = '$newIpAddress:2003';
      const pocketBasePath =
          '.\\pocketbase_0.22.20_windows_amd64\\pocketbase.exe';

      _pocketBaseProcess = await Process.start(
        pocketBasePath,
        ['serve', '--http=$baseUrl'],
        runInShell: true,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDatabaseOn', true);
      await prefs.setString('serverId', serverIdInput);
      await prefs.setString('ipAddress', newIpAddress);

      emit(state.copyWith(
        isDatabaseOn: true,
        serverId: serverIdInput,
        ipAddress: newIpAddress,
      ));
    } catch (e) {
      if (_pocketBaseProcess != null) {
        _pocketBaseProcess!.kill();
        _pocketBaseProcess = null;
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDatabaseOn', false);
      await prefs.setString('serverId', '');
      await prefs.setString('ipAddress', '');

      emit(state.copyWith(
        isDatabaseOn: false,
        serverId: '',
        ipAddress: '',
      ));
    }
  }

  Future<void> _startPocketBase(String ipAddress) async {
    final baseUrl = '$ipAddress:2003';
    const pocketBasePath =
        '.\\pocketbase_0.22.20_windows_amd64\\pocketbase.exe';
    _pocketBaseProcess = await Process.start(
      pocketBasePath,
      ['serve', '--http=$baseUrl'],
      runInShell: true,
    );
  }

  @override
  Future<void> close() {
    if (_pocketBaseProcess != null) {
      _pocketBaseProcess!.kill();
    }
    return super.close();
  }
}
