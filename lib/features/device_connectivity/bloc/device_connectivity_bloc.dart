import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:ble_grapher/core/constants/const.dart';
import 'package:ble_grapher/features/chat/model/chat_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:usb_serial/usb_serial.dart';
part 'device_connectivity_event.dart';
part 'device_connectivity_state.dart';

class DeviceConnectivityBloc
    extends Bloc<DeviceConnectivityEvent, DeviceConnectivityState> {
  String _messageBuffer = '';
  DeviceConnectivityBloc() : super(const DeviceConnectivityState()) {
    on<ConnectToDeviceEvent>(connectToDevice);
    on<RefreshDevicesEvent>(refreshDevices);
    on<DisconnectDeviceEvent>(disconnecDevice);
    on<SendDataEvent>(sendDataToDevice);
    on<UpdateErrorMessage>(updateErrorMessage);
    on<DataReceivedEvent>(dataReceivedFromDevice);
    on<ChooseBLEorUSBDeviceConnectivityEvent>(_connectToBLEorUSB);
    on<TurnOnBluetoothEvent>(_turnOnBluetooth);
    on<ListenToBluetoothAdapterEvent>(_listenToBLEState);
    on<SetBLETurnedOnorOFFEvent>(_setBLEstatus);
    on<ScanBLEDevicesEvent>(_scanBLE);
    on<AddBLEDevicesEvent>(_addBleDevices);
    on<ClearMessageCountEvent>(_clearMessageCount);
  }
  _clearMessageCount(
      ClearMessageCountEvent event, Emitter<DeviceConnectivityState> emit) {
    emit(state.copyWith(messageCount: 0));
  }

  _setBLEstatus(
      SetBLETurnedOnorOFFEvent event, Emitter<DeviceConnectivityState> emit) {
    emit(state.copyWith(isBLEStateON: event.isBLEON));
  }

  _listenToBLEState(ListenToBluetoothAdapterEvent event,
      Emitter<DeviceConnectivityState> emit) {
    FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      if (state == BluetoothAdapterState.on) {
        add(const SetBLETurnedOnorOFFEvent(true));
        // usually start scanning, connecting, etc
      } else {
        // show an error to the user, etc
        add(const SetBLETurnedOnorOFFEvent(false));
      }
    });
  }

  _addBleDevices(
      AddBLEDevicesEvent event, Emitter<DeviceConnectivityState> emit) {
    isAlreadyAdded(ScanResult device) {
      bool isAlreadyAdded = false;
      for (ScanResult dev in state.bluetoothDevices) {
        if (dev.device.remoteId == device.device.remoteId) {
          isAlreadyAdded = true;
          break;
        }
      }
      return isAlreadyAdded;
    }

    for (ScanResult device in event.bluetoothDevices) {
      if (!isAlreadyAdded(device)) {
        emit(state.copyWith(
            bluetoothDevices: List.of(state.bluetoothDevices)..add(device)));
      }
    }
  }

  _scanBLE(
      ScanBLEDevicesEvent event, Emitter<DeviceConnectivityState> emit) async {
    if (FlutterBluePlus.isScanningNow) return;
    emit(state.copyWith(bluetoothDevices: []));
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    var subscription = FlutterBluePlus.onScanResults.listen(
      (results) {
        print("Scan Result $results");
        if (results.isNotEmpty) {
          add(AddBLEDevicesEvent(results));
        }
      },
      onError: (e) => add(UpdateErrorMessage("$e")),
    );

    // cleanup: cancel subscription when scanning stops
    FlutterBluePlus.cancelWhenScanComplete(subscription);
  }

  _turnOnBluetooth(
      TurnOnBluetoothEvent event, Emitter<DeviceConnectivityState> emit) async {
    // first, check if bluetooth is supported by your hardware
    // Note: The platform is initialized on the first call to any FlutterBluePlus method.
    if (await FlutterBluePlus.isSupported == false) {
      emit(state.copyWith(
          errorMessage: "Bluetooth not supported by this device"));
      return;
    }
    if (Platform.isAndroid) {
      await FlutterBluePlus.turnOn();
    }
  }

  _connectToBLEorUSB(ChooseBLEorUSBDeviceConnectivityEvent event,
      Emitter<DeviceConnectivityState> emit) {
    emit(state.copyWith(connectToBLE: event.connectToBLE));
  }

  updateErrorMessage(
      UpdateErrorMessage event, Emitter<DeviceConnectivityState> emit) {
    emit(state.copyWith(errorMessage: event.error));
  }

  disconnecDevice(
      DisconnectDeviceEvent event, Emitter<DeviceConnectivityState> emit) {
    emit(state.copyWith(connectedDevice: const ConnectedDevice()));
  }

  refreshDevices(
      RefreshDevicesEvent event, Emitter<DeviceConnectivityState> emit) async {
    if (!state.connectToBLE) {
      emit(state.copyWith(devices: await UsbSerial.listDevices()));
      return;
    }
    add(ScanBLEDevicesEvent());
  }

  sendDataToDevice(
      SendDataEvent event, Emitter<DeviceConnectivityState> emit) async {
    try {
      if (state.connectedDevice.bleDevice != null) {
        List<BluetoothService> services =
            await state.connectedDevice.bleDevice!.discoverServices();
        for (var service in services) {
          var characteristics = service.characteristics;
          for (BluetoothCharacteristic c in characteristics) {
            if (c.uuid.toString() == state.bleCharUUID) {
              await c.write(utf8.encode(event.data));
              emit(state.copyWith(
                  lasMessageSent:
                      ChatMessage.sent(message: event.data, isSuccess: true)));
              return;
            }
          }
        }
      }
      if (state.connectedDevice.usbPort == null) {
        emit(state.copyWith(
            lasMessageSent: ChatMessage.sent(
                message: "'${event.data}' Error: Device not connected",
                isSuccess: false)));
        return;
      }
      Uint8List data = Uint8List.fromList(event.data.codeUnits);
      state.connectedDevice.usbPort?.write(data);
      emit(state.copyWith(
          lasMessageSent:
              ChatMessage.sent(message: event.data, isSuccess: true)));
    } catch (e) {
      emit(state.copyWith(
          lasMessageSent: ChatMessage.sent(
              message: "'${event.data}' Error: $e", isSuccess: false)));
    }
  }

  connectToDevice(
      ConnectToDeviceEvent event, Emitter<DeviceConnectivityState> emit) async {
    if (event.bleDevice != null) {
      try {
        emit(state.copyWith(
            connectedDevice: ConnectedDevice(bleDevice: event.bleDevice)));
        await event.bleDevice?.disconnect();
        await event.bleDevice!
            .connect(timeout: const Duration(seconds: 5), autoConnect: false);
        event.bleDevice!.connectionState
            .listen((BluetoothConnectionState deviceState) {
          if (deviceState == BluetoothConnectionState.connected) {
            emit(state.copyWith(
                connectedDevice: ConnectedDevice(bleDevice: event.bleDevice)));
          }
          if (deviceState == BluetoothConnectionState.disconnected) {
            add(DisconnectDeviceEvent());
          }
        });
        List<BluetoothService> services =
            await event.bleDevice!.discoverServices();
        for (var service in services) {
          // do something with service
          // Reads all characteristics
          var characteristics = service.characteristics;
          for (BluetoothCharacteristic c in characteristics) {
            if (c.uuid.toString() == state.bleCharUUID) {
              await c.setNotifyValue(true);
              // c.onValueReceived
              c.onValueReceived.listen((List<int> data) {
                int backspacesCounter = 0;
                for (var byte in data) {
                  if (byte == 8 || byte == 127) {
                    backspacesCounter++;
                  }
                }
                Uint8List buffer = Uint8List(data.length - backspacesCounter);
                int bufferIndex = buffer.length;

                // Apply backspace control character
                backspacesCounter = 0;
                for (int i = data.length - 1; i >= 0; i--) {
                  if (data[i] == 8 || data[i] == 127) {
                    backspacesCounter++;
                  } else {
                    if (backspacesCounter > 0) {
                      backspacesCounter--;
                    } else {
                      buffer[--bufferIndex] = data[i];
                    }
                  }
                }
                add(DataReceivedEvent(buffer));
              });
            }
          }
        }
      } catch (e) {
        add(const UpdateErrorMessage("Faild to connect!"));
        add(DisconnectDeviceEvent());
      }
      return;
    }

    if (event.usbDevice == null) return;
    UsbPort? port;
    port = await event.usbDevice?.create();
    if (port == null) {
      add(const UpdateErrorMessage("Failed to connect!"));
      return;
    }
    bool openResult = await port.open();
    if (!openResult) {
      add(const UpdateErrorMessage("Failed to connect!"));
      return;
    }

    await port.setDTR(true);
    await port.setRTS(true);

    port.setPortParameters(
        115200, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

    // print first result and close port.
    port.inputStream?.listen((Uint8List event) {
      // print("data Received");
      add(DataReceivedEvent(event));
      // port?.close();
    }).onDone(() {
      add(DisconnectDeviceEvent());
    });
    // await port.write(Uint8List.fromList([0x10, 0x00]));
    emit(state.copyWith(
        connectedDevice:
            ConnectedDevice(usbDevice: event.usbDevice, usbPort: port)));
  }

  dataReceivedFromDevice(
      DataReceivedEvent event, Emitter<DeviceConnectivityState> emit) {
    Uint8List data = event.data;

    int backspacesCounter = 0;
    for (var byte in data) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    }
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      String receivedString = backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString.substring(0, index);
      _messageBuffer = dataString.substring(index);
      if (receivedString.length > 1) {
        List<String> split = receivedString.split('\n');
        for (var element in split) {
          try {
            if (element.trim().isNotEmpty) {
              emit(state.copyWith(
                  messageCount: state.messageCount + 1,
                  lastMessage: element.trim().replaceAll("\r", "")));
            }
          } catch (e) {
            add(UpdateErrorMessage("Error! $e in parsing ($element)"));
          }
        }
      }
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
  }
}
