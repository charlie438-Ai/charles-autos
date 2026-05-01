import 'package:flutter/material.dart';

class CurrencyConverter extends StatefulWidget {
  final double basePriceUSD;

  const CurrencyConverter({super.key, required this.basePriceUSD});

  @override
  State<CurrencyConverter> createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  String selectedCurrency = 'USD';
  
  // Hardcoded approximate exchange rates against USD
  final Map<String, double> exchangeRates = {
    'USD': 1.0,
    'EUR': 0.93,
    'GBP': 0.80,
    'GHS': 13.5, // Ghanaian Cedi
    'NGN': 1150.0, // Nigerian Naira
    'CAD': 1.37,
    'AUD': 1.52,
  };

  final Map<String, String> currencySymbols = {
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'GHS': 'GH₵',
    'NGN': '₦',
    'CAD': 'C\$',
    'AUD': 'A\$',
  };

  @override
  Widget build(BuildContext context) {
    final convertedPrice = widget.basePriceUSD * exchangeRates[selectedCurrency]!;
    final symbol = currencySymbols[selectedCurrency]!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Local Currency', style: TextStyle(color: Colors.white70)),
              DropdownButton<String>(
                value: selectedCurrency,
                dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                underline: const SizedBox(),
                items: exchangeRates.keys.map((String currency) {
                  return DropdownMenuItem<String>(
                    value: currency,
                    child: Text(currency, style: const TextStyle(fontWeight: FontWeight.bold)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedCurrency = newValue;
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$symbol${convertedPrice.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
