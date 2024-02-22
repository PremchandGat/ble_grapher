part of 'device_connectivity_bloc.dart';

class ConnectedDevice {
  final UsbDevice? usbDevice;
  final UsbPort? usbPort;
  final BluetoothDevice? bleDevice;
  const ConnectedDevice({this.bleDevice, this.usbDevice, this.usbPort});
}

class DeviceConnectivityState extends Equatable {
  const DeviceConnectivityState(
      {this.devices = const [],
      this.lasMessageSent = const EmptyChatMessage(
        type: ChatMessageType.sent,
      ),
      this.bluetoothDevices = const [],
      this.isBLEStateON = false,
      this.connectedDevice = const ConnectedDevice(),
      this.errorMessage = "",
      this.connectToBLE = true,
      this.lastMessage = "",
      this.bleCharUUID = Constatns.bleUUID,
      this.messageCount = 0});
  final int messageCount;
  final String bleCharUUID;
  final String lastMessage;
  final ChatMessage lasMessageSent;
  final ConnectedDevice connectedDevice;
  final String errorMessage;
  final List<UsbDevice> devices;
  final bool connectToBLE;
  final bool isBLEStateON;
  final List<ScanResult> bluetoothDevices;
  bool get isConnected =>
      connectedDevice.usbDevice != null || connectedDevice.bleDevice != null;

  DeviceConnectivityState copyWith(
      {ConnectedDevice? connectedDevice,
      List<UsbDevice>? devices,
      List<ScanResult>? bluetoothDevices,
      bool? isBLEStateON,
      bool? connectToBLE,
      String? lastMessage,
      String? errorMessage,
      String? bleCharUUID,
      ChatMessage? lasMessageSent,
      int? messageCount}) {
    return DeviceConnectivityState(
        lasMessageSent: lasMessageSent ?? this.lasMessageSent,
        bleCharUUID: bleCharUUID ?? this.bleCharUUID,
        errorMessage: errorMessage ?? this.errorMessage,
        messageCount: messageCount ?? this.messageCount,
        lastMessage: lastMessage ?? this.lastMessage,
        bluetoothDevices: bluetoothDevices ?? this.bluetoothDevices,
        isBLEStateON: isBLEStateON ?? this.isBLEStateON,
        connectToBLE: connectToBLE ?? this.connectToBLE,
        connectedDevice: connectedDevice ?? this.connectedDevice,
        devices: devices ?? this.devices);
  }

  @override
  List<Object> get props => [
        lasMessageSent,
        bleCharUUID,
        isConnected,
        lastMessage,
        messageCount,
        bluetoothDevices,
        connectToBLE,
        isBLEStateON,
        errorMessage,
        connectedDevice,
        devices,
      ];
}
