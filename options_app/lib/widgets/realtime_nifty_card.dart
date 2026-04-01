import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RealtimeNiftyCard extends StatefulWidget {
  const RealtimeNiftyCard({Key? key}) : super(key: key);

  @override
  _RealtimeNiftyCardState createState() => _RealtimeNiftyCardState();
}

class _RealtimeNiftyCardState extends State<RealtimeNiftyCard> {
  double? _nifty;
  String _status = 'Loading';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadNifty();
    _timer = Timer.periodic(Duration(seconds: 30), (_) => _loadNifty());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadNifty() async {
    setState(() {
      _status = 'Fetching';
    });

    try {
      // Use NSE India API for NIFTY 50
      final nseUri = Uri.parse('https://www.nseindia.com/api/equity-stockIndices?index=NIFTY%2050');
      print('🔍 Fetching from NSE India: $nseUri');

      final nseRes = await http.get(nseUri, headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        'Accept': 'application/json',
      }).timeout(Duration(seconds: 15));

      print('📡 NSE response status: ${nseRes.statusCode}');
      print('📄 NSE response body length: ${nseRes.body.length} chars');

      if (nseRes.statusCode == 200) {
        print('✅ NSE response body length: ${nseRes.body.length}');
        final data = jsonDecode(nseRes.body);
        print('📊 NSE data structure: ${data.keys}');

        final result = data['data'] as List<dynamic>?;
        print('🎯 NSE result array: ${result?.length ?? 0} items');

        if (result != null && result.isNotEmpty) {
          final niftyData = result[0] as Map<String, dynamic>;
          print('💰 NIFTY data keys: ${niftyData.keys}');
          print('💰 Full NIFTY data: $niftyData');

          final price = niftyData['lastPrice'];
          print('💵 Price value: $price (type: ${price?.runtimeType})');

          if (price != null) {
            final fetched = (price as num).toDouble();
            print('✅ NSE fetched value: $fetched');

            setState(() {
              _nifty = fetched;
              _status = 'Realtime (NSE India)';
            });
            return;
          } else {
            print('❌ Price is null in NIFTY data');
          }
        } else {
          print('❌ No results in NSE response');
        }
      } else {
        print('❌ NSE HTTP error: ${nseRes.statusCode}');
        print('❌ NSE response body: ${nseRes.body}');
      }

      throw Exception('NSE API failed');
    } catch (error) {
      print('❌ Error fetching Nifty: $error');
      print('❌ Error type: ${error.runtimeType}');
      if (error is http.ClientException) {
        print('❌ Network error: ${error.message}');
      }
      setState(() {
        _status = 'Offline';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final display = _nifty?.toStringAsFixed(2) ?? '--';

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.grey[100],
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Realtime Nifty', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 4),
                Text('Value: $display', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                SizedBox(height: 2),
                Text('Status: $_status', style: TextStyle(fontSize: 12, color: Colors.grey[700])),
              ],
            ),
            Icon(Icons.show_chart, size: 32, color: Colors.blueAccent),
          ],
        ),
      ),
    );
  }
}
