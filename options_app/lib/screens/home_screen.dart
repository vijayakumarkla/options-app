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

class HomeScreen extends StatelessWidget {
  final double nifty = 22500;
  final double vix = 25;
  final String trend = "Bearish";

  String getMarketType() {
    if (vix > 20 && trend == "Bearish") return "Bearish";
    if (vix < 20 && trend == "Bullish") return "Bullish";
    return "Sideways";
  }

  @override
  Widget build(BuildContext context) {
    String marketType = getMarketType();

    return Scaffold(
      appBar: AppBar(title: Text("📊 Options Strategy")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MarketBanner(type: marketType),
            RealtimeNiftyCard(),
            MarketCard(nifty: nifty, vix: vix, trend: trend),
            Row(
              children: [
                Expanded(
                  child: StrategyCard(type: marketType),
                ),
                Expanded(
                  child: TradeSetup(type: marketType, nifty: nifty),
                ),
              ],
            ),
            Rules(type: marketType),
            DecisionTable(type: marketType),
            StopLoss(type: marketType),
            IncomePlan(),
          ],
        ),
      ),
    );
  }
}

