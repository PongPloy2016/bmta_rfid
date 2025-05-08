import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:zebra123/zebra123.dart';

import 'helpers.dart';

/// bridge between flutter and android.
class Bridge {
  var _interface = Interfaces.unknown;
  Interfaces get interface => _interface;

  var _status = Status.disconnected;
  Status get status => _status;

  final List<Zebra123> _listeners = [];

  final List<Interfaces> _supported = [];
  bool supports(Interfaces interface) => _supported.contains(interface);

  late final MethodChannel _methodChannel;
  late final EventChannel _eventChannel;

  static Bridge? _singleton;

  /// Constructs a singleton instance of [Bridge].
  ///
  /// [Bridge] is designed to work as a singleton.
  // When a second instance is created, the first instance will not be able to listen to the
  // EventChannel because it is overridden. Forcing the class to be a singleton class can prevent
  // misuse of creating a second instance from a programmer.
  factory Bridge({Zebra123? listener}) {
    _singleton ??= Bridge._();
    if (listener != null) {
      _singleton!.addListener(listener);
    }
    return _singleton!;
  }

  Bridge._() {
    // create method channel
    _methodChannel = const MethodChannel("methodX");

    // create event channel
    _eventChannel = const EventChannel("eventX");

    // listen for events
    _eventChannel.receiveBroadcastStream().listen(_eventListener);
  }

  // returns true is specified listener is ion the _listener list
  bool contains(Zebra123 listener) => _listeners.contains(listener);

  // listen for zebra events
  void addListener(Zebra123 listener) {
    if (!contains(listener)) {
      _listeners.add(listener);
    }
  }

  void onTagRead(
      {required Function(RfidTag tag) onTagRead,
      required Function(List<RfidTag> tags) onTagsRead}) {
    if (contains(_listeners.first)) {
      _listeners.add(Zebra123(callback: (interface, event, data) {
        if (event == Events.error) {
       //   if (data is List<RfidTag>) {

            var tags =  [
      RfidTag(epc: 'EPC2', antenna: 2, rssi: -60, distance: 12,
              memoryBankData: 'D2', lockData: 'L2', size: 64,
              seen: 'now', interface: Interfaces.unknown),
      RfidTag(epc: 'EPC3', antenna: 1, rssi: -55, distance: 11,
              memoryBankData: 'D3', lockData: 'L3', size: 32,
              seen: 'now', interface: Interfaces.unknown),
    ];
      onTagsRead.call(tags);
          } else if (data is RfidTag) {
            onTagRead(data);
          }
        }
    //  }
      ));
    }
  }

  // stop listening to zebra events
  void removeListener(Zebra123 listener) {
    if (contains(listener)) {
      _listeners.remove(listener);
    }
  }

  // set device mode
  void setMode(Modes mode) {
    _methodChannel.invokeMethod("mode", {"mode": fromEnum(mode)});
  }

  // invoke scan request
  void scan(Requests request) {
    _methodChannel.invokeMethod("scan", {"request": fromEnum(request)});
  }

  // invoke tracking request
  void track(Requests request, {List<String>? tags}) {
    String list = "";
    for (var tag in tags ?? []) {
      if (list == "") {
        list = tag;
      } else {
        list += ",$tag";
      }
    }
    _methodChannel
        .invokeMethod("track", {"request": fromEnum(request), "tags": list});
  }

  // invoke write request
  void write(String epc,
      {String? epcNew, double? password, double? passwordNew, String? data}) {
    _methodChannel.invokeMethod("write", {
      "epc": epc,
      "epcNew": epcNew ?? "",
      "password": (password ?? "").toString(),
      "passwordNew": (passwordNew ?? "").toString(),
      "data": data ?? "",
    });
  }

  // zebra events listener
  void _eventListener(dynamic payload) {
    try {
      final map = Map<String, dynamic>.from(payload);
      _interface =
          toEnum(map['eventSource'] as String, Interfaces.values) ?? _interface;
      final event =
          toEnum(map['eventName'] as String, Events.values) ?? Events.unknown;

      switch (event) {
        case Events.readRfid:
          List<RfidTag> list = [];
          List<dynamic> tags = map["tags"];
          for (var i = 0; i < tags.length; i++) {
            var tag = Map<String, dynamic>.from(tags[i]);
            tag["eventSource"] = fromEnum(_interface);
            list.add(RfidTag.fromMap(tag));
          }

          // notify listeners
          for (var listener in _listeners) {
            listener.callback(_interface, event, list);
          }

          break;

        case Events.readBarcode:
          List<Barcode> list = [];
          var tag = Barcode.fromMap(map);
          list.add(tag);

          // notify listeners
          for (var listener in _listeners) {
            listener.callback(_interface, event, list);
          }

          break;

        case Events.writeFail:
          var error = Error.fromMap(map);

          // notify listeners
          for (var listener in _listeners) {
            listener.callback(_interface, event, error);
          }
          break;

        case Events.writeSuccess:
          var tag = RfidTag.fromMap(map);

          // notify listeners
          for (var listener in _listeners) {
            listener.callback(_interface, event, tag);
          }
          break;

        case Events.support:
          if (map.containsKey(fromEnum(Interfaces.rfidapi3))) {
            var supports = toBool(map[fromEnum(Interfaces.rfidapi3)]) ?? false;
            if (supports && !_supported.contains(Interfaces.rfidapi3)) {
              _supported.add(Interfaces.rfidapi3);
            }
          }
          if (map.containsKey(fromEnum(Interfaces.datawedge))) {
            var supports = toBool(map[fromEnum(Interfaces.datawedge)]) ?? false;
            if (supports && !_supported.contains(Interfaces.datawedge)) {
              _supported.add(Interfaces.datawedge);
            }
          }
          break;

        case Events.error:
          var error = Error.fromMap(map);

          // notify listeners
          for (var listener in _listeners) {
            listener.callback(_interface, event, error);
          }

          break;

        case Events.connectionStatus:
          var connection = ConnectionStatus.fromMap(map);
          _status = connection.status;

          // notify listeners
          for (var listener in _listeners) {
            listener.callback(_interface, event, connection);
          }

          break;

        // unknown event
        default:
          // notify listeners
          for (var listener in _listeners) {
            listener.callback(_interface, event, null);
          }
          break;
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }
}
