import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const FuelGoApp());
}

// --- DESIGN TOKENS ---
const Color bgMain = Color(0xFF07091A);
const Color bgApp = Color(0xFF0C0F1E);
const Color surfaceColor = Color(0xFF141829);
const Color cardColor = Color(0xFF1B2035);
const Color amberAccent = Color(0xFFF5A623);
const Color cyanAccent = Color(0xFF22D3EE);
const Color greenAccent = Color(0xFF34D399);
const Color textHi = Color(0xFFE8EAF0);
const Color textMuted = Color(0xFF9CA3AF);
const Color borderColor = Color(0x1AFFFFFF);

class FuelGoApp extends StatelessWidget {
  const FuelGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FuelGo Prototype',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: bgMain,
        brightness: Brightness.dark,
        textTheme: GoogleFonts.dmSansTextTheme(
          Theme.of(context).textTheme.apply(bodyColor: textHi, displayColor: textHi),
        ),
      ),
      home: const MainNavigator(),
    );
  }
}

// --- MAIN NAVIGATOR ---
class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _currentIndex = 0;

  void _switchTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeTab(onNavigate: _switchTab),
          ReserveTab(onNavigate: _switchTab),
          ConfirmTab(onNavigate: _switchTab),
          const AccountTab(), // <- FIX ADDED HERE
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: surfaceColor,
          border: Border(top: BorderSide(color: borderColor)),
        ),
        padding: const EdgeInsets.only(bottom: 24, top: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home_filled, 'HOME'),
            _buildNavItem(1, Icons.local_gas_station, 'RESERVE'),
            _buildNavItem(2, Icons.confirmation_num, 'TICKETS'),
            _buildNavItem(3, Icons.person, 'ACCOUNT'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => _switchTab(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? amberAccent : textMuted, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isActive ? amberAccent : textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

// --- SCREEN 1: HOME ---
class HomeTab extends StatelessWidget {
  final Function(int) onNavigate;
  const HomeTab({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('GOOD MORNING', style: TextStyle(fontSize: 12, color: textMuted, letterSpacing: 1.5)),
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.syne(fontSize: 24, fontWeight: FontWeight.w800, color: textHi),
                      children: const [
                        TextSpan(text: 'Juan '),
                        TextSpan(text: 'Dela Cruz', style: TextStyle(color: amberAccent)),
                        TextSpan(text: ' 👋'),
                      ],
                    ),
                  ),
                ],
              ),
              const CircleAvatar(
                backgroundColor: amberAccent,
                radius: 23,
                child: Text('J', style: TextStyle(color: bgMain, fontWeight: FontWeight.bold, fontSize: 18)),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Vehicle Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [cardColor, surfaceColor]),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                Container(
                  width: 50, height: 50,
                  decoration: BoxDecoration(color: amberAccent.withOpacity(0.15), borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Icons.directions_car, color: amberAccent),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Toyota Vios', style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.bold)),
                      const Text('ABC 1234 · Gray', style: TextStyle(color: textMuted, fontSize: 12)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: amberAccent, borderRadius: BorderRadius.circular(8)),
                  child: const Text('GAS 95', style: TextStyle(color: bgMain, fontSize: 11, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Quick Action
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: amberAccent,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            ),
            onPressed: () => onNavigate(1),
            child: Text(
              '⚡ Quick Reserve Fuel',
              style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.bold, color: bgMain),
            ),
          ),
        ],
      ),
    );
  }
}

// --- SCREEN 2: RESERVE (Functional State) ---
class ReserveTab extends StatefulWidget {
  final Function(int) onNavigate;
  const ReserveTab({super.key, required this.onNavigate});

  @override
  State<ReserveTab> createState() => _ReserveTabState();
}

class _ReserveTabState extends State<ReserveTab> {
  // Functions & State Setup
  String selectedFuel = 'premium';
  final Map<String, double> prices = {'unleaded': 59.40, 'premium': 63.15, 'diesel': 55.90};
  
  String currentUnit = 'liter'; // 'liter' or 'peso'
  double amountValue = 20.0;

  void _setFuel(String fuel) {
    setState(() => selectedFuel = fuel);
  }

  void _toggleUnit(String unit) {
    setState(() {
      currentUnit = unit;
      amountValue = unit == 'liter' ? 20.0 : 1263.0; // Reset to default on toggle
    });
  }

  void _adjustAmount(double delta) {
    setState(() {
      amountValue += delta;
      if (currentUnit == 'liter') {
        amountValue = amountValue.clamp(1.0, 60.0);
      } else {
        amountValue = amountValue.clamp(100.0, 5000.0);
      }
    });
  }

  // Equivalent calculation function
  String get _equivalentText {
    double price = prices[selectedFuel]!;
    if (currentUnit == 'liter') {
      double totalPeso = amountValue * price;
      return "≈ ₱${totalPeso.toStringAsFixed(2)} at today's price";
    } else {
      double totalLiters = amountValue / price;
      return "≈ ${totalLiters.toStringAsFixed(2)} L of fuel";
    }
  }

  @override
  Widget build(BuildContext context) {
    double currentPrice = prices[selectedFuel]!;
    double totalCost = currentUnit == 'liter' ? (amountValue * currentPrice) : amountValue;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: textHi),
                onPressed: () => widget.onNavigate(0),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Reserve Fuel', style: GoogleFonts.syne(fontSize: 20, fontWeight: FontWeight.bold)),
                  const Text('SEAOIL Philippines · 0.8 km', style: TextStyle(color: textMuted, fontSize: 12)),
                ],
              )
            ],
          ),
          const SizedBox(height: 24),

          // Fuel Selector
          const Text('FUEL TYPE', style: TextStyle(fontSize: 11, color: textMuted, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildFuelOption('unleaded', 'Unleaded 91', '🟢', prices['unleaded']!),
              const SizedBox(width: 10),
              _buildFuelOption('premium', 'Premium 95', '🔶', prices['premium']!),
              const SizedBox(width: 10),
              _buildFuelOption('diesel', 'Diesel', '🟤', prices['diesel']!),
            ],
          ),
          const Divider(color: borderColor, height: 40),

          // Amount Toggles & Input
          const Text('AMOUNT', style: TextStyle(fontSize: 11, color: textMuted, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(10), border: Border.all(color: borderColor)),
            child: Row(
              children: [
                Expanded(child: _buildUnitToggle('liter', 'By Liter (L)')),
                Expanded(child: _buildUnitToggle('peso', 'By Amount (₱)')),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: amberAccent, width: 1.5),
            ),
            child: Row(
              children: [
                Text(currentUnit == 'liter' ? 'L' : '₱', style: GoogleFonts.syne(fontSize: 20, color: amberAccent, fontWeight: FontWeight.bold)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    currentUnit == 'liter' ? amountValue.toInt().toString() : amountValue.toStringAsFixed(0),
                    style: GoogleFonts.syne(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
                _buildStepperBtn(-5, () => _adjustAmount(currentUnit == 'liter' ? -5 : -100)),
                const SizedBox(width: 8),
                _buildStepperBtn(5, () => _adjustAmount(currentUnit == 'liter' ? 5 : 100)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(_equivalentText, style: const TextStyle(color: textMuted, fontSize: 13)),
          
          const Divider(color: borderColor, height: 40),

          // Price Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: borderColor)),
            child: Column(
              children: [
                _buildSummaryRow('Rate (today\'s lock-in)', '₱${currentPrice.toStringAsFixed(2)}/L'),
                const SizedBox(height: 8),
                _buildSummaryRow('Service Fee', '₱0.00'),
                const Divider(color: borderColor, height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Est. Cost', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('₱${totalCost.toStringAsFixed(2)}', style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.bold, color: amberAccent)),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 20),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: amberAccent,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            ),
            onPressed: () => widget.onNavigate(2),
            child: Text('🔒 Lock-In & Reserve →', style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.bold, color: bgMain)),
          ),
        ],
      ),
    );
  }

  Widget _buildFuelOption(String id, String name, String icon, double price) {
    bool isSelected = selectedFuel == id;
    return Expanded(
      child: GestureDetector(
        onTap: () => _setFuel(id),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? amberAccent.withOpacity(0.15) : surfaceColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? amberAccent : borderColor),
          ),
          child: Column(
            children: [
              Text(icon, style: const TextStyle(fontSize: 22)),
              const SizedBox(height: 6),
              Text(name, textAlign: TextAlign.center, style: GoogleFonts.syne(fontSize: 12, fontWeight: FontWeight.bold, color: isSelected ? amberAccent : textHi)),
              Text('₱${price.toStringAsFixed(2)}/L', style: const TextStyle(fontSize: 10, color: textMuted)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUnitToggle(String id, String label) {
    bool isSelected = currentUnit == id;
    return GestureDetector(
      onTap: () => _toggleUnit(id),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? amberAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.syne(fontSize: 12, fontWeight: FontWeight.bold, color: isSelected ? bgMain : textMuted),
        ),
      ),
    );
  }

  Widget _buildStepperBtn(int value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(8), border: Border.all(color: borderColor)),
        alignment: Alignment.center,
        child: Text(value > 0 ? '+' : '−', style: const TextStyle(color: amberAccent, fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: textMuted, fontSize: 13)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }
}

// --- SCREEN 3: CONFIRMATION ---
class ConfirmTab extends StatelessWidget {
  final Function(int) onNavigate;
  const ConfirmTab({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72, height: 72,
                decoration: BoxDecoration(
                  color: greenAccent.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: greenAccent.withOpacity(0.4), width: 2),
                ),
                alignment: Alignment.center,
                child: const Text('✅', style: TextStyle(fontSize: 32)),
              ),
              const SizedBox(height: 16),
              Text('Reservation Confirmed!', style: GoogleFonts.syne(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                'Your fuel is locked in at today\'s price.\nShow the QR code at the station.',
                textAlign: TextAlign.center,
                style: TextStyle(color: textMuted),
              ),
              const SizedBox(height: 40),
              
              // Actions
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: cyanAccent,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                icon: const Icon(Icons.navigation, color: bgMain),
                label: Text('Navigate to Station', style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.bold, color: bgMain)),
                onPressed: () {},
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: borderColor, width: 1.5),
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                onPressed: () => onNavigate(0),
                child: Text('← Back to Home', style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.bold, color: textMuted)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- SCREEN 4: ACCOUNT (Placeholder Fix) ---
class AccountTab extends StatelessWidget {
  const AccountTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person, size: 64, color: textMuted),
            const SizedBox(height: 16),
            Text(
              'Account Settings\n(Coming Soon)',
              textAlign: TextAlign.center,
              style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.bold, color: textMuted),
            ),
          ],
        ),
      ),
    );
  }
}