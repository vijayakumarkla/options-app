import 'package:flutter/material.dart';
import '../widgets/realtime_nifty_card.dart';
import '../widgets/market_card.dart';
import '../widgets/market_banner.dart';
import '../widgets/strategy_card.dart';
import '../widgets/trade_setup.dart';
import '../widgets/rules.dart';
import '../widgets/decision_table.dart';
import '../widgets/stop_loss.dart';
import '../widgets/income_plan.dart';
import '../widgets/exit_scenario.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double? nifty;
  double vix = 18;
  String trend = "Bullish";

  String getMarketType() {
    if (vix > 20 && trend == "Bearish") return "Bearish";
    if (vix < 20 && trend == "Bullish") return "Bullish";
    return "Sideways";
  }

  String getStrategy() {
    if (vix > 20) return "Iron Condor";

    if (vix < 15) {
      if (trend == "Bullish") return "Bull Call Spread";
      if (trend == "Bearish") return "Bear Put Spread";
    }

    if (vix <= 20) {
      if (trend == "Bullish") return "Bull Put Spread";
      if (trend == "Bearish") return "Bear Call Spread";
    }

    return "Iron Condor";
  }

  Map<String, dynamic> getTradeSetup() {
    double atm = ((nifty ?? 0) / 50).round() * 50;

    switch (getStrategy()) {
      case "Bull Call Spread":
        return {"buy": atm, "sell": atm + 100};
      case "Bear Put Spread":
        return {"buy": atm, "sell": atm - 100};
      case "Bull Put Spread":
        return {"sell": atm, "buy": atm - 100};
      case "Bear Call Spread":
        return {"sell": atm, "buy": atm + 100};
      case "Iron Condor":
        return {
          "sellCE": atm + 100,
          "buyCE": atm + 200,
          "sellPE": atm - 100,
          "buyPE": atm - 200,
        };
      default:
        return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    final strategy = getStrategy();
    final trade = getTradeSetup();
    final marketType = getMarketType();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("📊 Options Strategy"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MarketBanner(type: marketType),

            RealtimeNiftyCard(
              onNiftyUpdate: (value) => setState(() => nifty = value),
            ),

            // 🔥 VIX
            _cardWrapper(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _title("VIX", Icons.show_chart),
                  Row(
                    children: [
                      _btn(Icons.remove, () {
                        setState(() {
                          if (vix > 10) vix--;
                        });
                      }),
                      SizedBox(width: 10),
                      Text(vix.toStringAsFixed(0),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(width: 10),
                      _btn(Icons.add, () {
                        setState(() {
                          if (vix < 50) vix++;
                        });
                      }),
                    ],
                  )
                ],
              ),
            ),

            // 🔥 TREND
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: TrendSlider(
                selected: trend,
                onChanged: (val) => setState(() => trend = val),
              ),
            ),

            MarketCard(nifty: nifty ?? 0, vix: vix, trend: trend),

            StrategyCard(type: strategy, trade: trade),

            TradeSetup(type: strategy, nifty: nifty ?? 0, trade: trade),

            Rules(strategy: strategy, nifty: nifty ?? 0, trade: trade),

            DecisionTable(nifty: nifty ?? 0, strategy: strategy),

            StopLoss(type: marketType),

            ExitScenario(nifty: nifty ?? 0, strategy: strategy, trade: trade),

            IncomePlan(),
          ],
        ),
      ),
    );
  }

  Widget _cardWrapper({required Widget child}) {
    return Card(
      margin: EdgeInsets.all(12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(padding: EdgeInsets.all(14), child: child),
    );
  }

  Widget _title(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20),
        SizedBox(width: 6),
        Text(text,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _btn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 16,
        backgroundColor: Colors.blue,
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}

// 🔥 Trend Slider
class TrendSlider extends StatelessWidget {
  final String selected;
  final Function(String) onChanged;

  const TrendSlider({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final options = ["Bullish", "Sideways", "Bearish"];

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.blue[200],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: options.map((opt) {
          bool active = opt == selected;

          IconData icon = opt == "Bullish"
              ? Icons.trending_up
              : opt == "Bearish"
                  ? Icons.trending_down
                  : Icons.trending_flat;

          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(opt),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: active ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(icon,
                    color: active ? Colors.white : Colors.black),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}