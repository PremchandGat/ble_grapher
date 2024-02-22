part of 'device_connectivity_bloc.dart';

sealed class DeviceConnectivityEvent extends Equatable {
  const DeviceConnectivityEvent();

  @override
  List<Object> get props => [];
}

class RefreshDevicesEvent extends DeviceConnectivityEvent {}

class ConnectToDeviceEvent extends DeviceConnectivityEvent {
  final UsbDevice? usbDevice;
  final BluetoothDevice? bleDevice;
  const ConnectToDeviceEvent({this.usbDevice, this.bleDevice});
}

class SendDataEvent extends DeviceConnectivityEvent {
  final String data;
  const SendDataEvent(this.data);
}

class DisconnectDeviceEvent extends DeviceConnectivityEvent {}

class UpdateErrorMessage extends DeviceConnectivityEvent {
  final String error;
  const UpdateErrorMessage(this.error);
}

class DataReceivedEvent extends DeviceConnectivityEvent {
  final Uint8List data;
  const DataReceivedEvent(this.data);
}

class ChooseBLEorUSBDeviceConnectivityEvent extends DeviceConnectivityEvent {
  final bool connectToBLE;
  const ChooseBLEorUSBDeviceConnectivityEvent(this.connectToBLE);
}

class TurnOnBluetoothEvent extends DeviceConnectivityEvent {}

class ListenToBluetoothAdapterEvent extends DeviceConnectivityEvent {}

class SetBLETurnedOnorOFFEvent extends DeviceConnectivityEvent {
  final bool isBLEON;
  const SetBLETurnedOnorOFFEvent(this.isBLEON);
}

class AddBLEDevicesEvent extends DeviceConnectivityEvent {
  final List<ScanResult> bluetoothDevices;
  const AddBLEDevicesEvent(this.bluetoothDevices);
}

class ScanBLEDevicesEvent extends DeviceConnectivityEvent {}

class ClearMessageCountEvent extends DeviceConnectivityEvent {}
