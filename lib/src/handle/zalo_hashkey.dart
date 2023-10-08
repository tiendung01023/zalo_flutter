import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './zalo_flutter.dart';

class ZaloHashKeyAndroid extends StatefulWidget {
  const ZaloHashKeyAndroid({Key? key}) : super(key: key);

  @override
  State<ZaloHashKeyAndroid> createState() => _ZaloHashKeyAndroidState();
}

class _ZaloHashKeyAndroidState extends State<ZaloHashKeyAndroid> {
  String? _hashKey;
  bool _isCopied = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      ZaloFlutter.getHashKeyAndroid().then((String? value) {
        _hashKey = value;
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? Column(
            children: [
              Text("HashKey ANDROID", textAlign: TextAlign.center),
              Text("Copy it to Dashboard", textAlign: TextAlign.center),
              Text("[https://developers.zalo.me/app/{your_app_id}/login]",
                  textAlign: TextAlign.center),
              Text(_hashKey ?? '',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              ElevatedButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _hashKey ?? ''));
                  setState(() {
                    _isCopied = true;
                  });
                },
                child: Text(_isCopied ? "COPIED" : "COPY"),
              )
            ],
          )
        : const SizedBox();
  }
}
