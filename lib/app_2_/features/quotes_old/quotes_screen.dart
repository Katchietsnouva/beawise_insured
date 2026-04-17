import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:insured/app_2/data/models/quote_old_model.dart';

class QuotesScreen_old extends StatelessWidget {
  QuotesScreen_old({super.key});

  // Mock data – later from provider / riverpod
  final List<Quote_old> quotes = [
    Quote_old(id: 'q1', clientId: '1', amount: 12500, status: 'accepted'),
    Quote_old(id: 'q2', clientId: '2', amount: 8700, status: 'pending'),
    Quote_old(id: 'q3', clientId: '3', amount: 15000, status: 'pending'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Quotes', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: quotes.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (ctx, i) {
          final quote = quotes[i];
          return _buildQuoteCard(ctx, quote);
        },
      ),
    );
  }

  Widget _buildQuoteCard(BuildContext context, Quote_old quote) {
    Color statusColor = switch (quote.status) {
      'accepted' => Colors.green,
      'pending' => Colors.orange,
      _ => Colors.grey,
    };

    return Card(
      color: Colors.white.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.2),
          child: Text(quote.id.substring(0, 2).toUpperCase()),
        ),
        title: Text(
          'Quote #${quote.id}',
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          'Client ID: ${quote.clientId}',
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${quote.amount.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                quote.status.toUpperCase(),
                style: TextStyle(color: statusColor, fontSize: 10),
              ),
            ),
          ],
        ),
        onTap: () {
          // Use go_router navigation instead of Navigator.pushNamed
          context.push('/quote-detail-old', extra: quote);
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:insured/app_2/data/models/quote_model.dart';

// class QuotesScreen_old extends StatelessWidget {
//   QuotesScreen_old({super.key});

//   // Mock data – would come from provider
//   final List<Quote> quotes = [
//     Quote(id: 'q1', clientId: '1', amount: 12500, status: 'accepted'),
//     Quote(id: 'q2', clientId: '2', amount: 8700, status: 'pending'),
//     Quote(id: 'q3', clientId: '3', amount: 15000, status: 'pending'),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Quotes', style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: ListView.separated(
//         padding: const EdgeInsets.all(16),
//         itemCount: quotes.length,
//         separatorBuilder: (_, __) => const SizedBox(height: 12),
//         itemBuilder: (ctx, i) {
//           final quote = quotes[i];
//           return _buildQuoteCard(ctx, quote);
//         },
//       ),
//     );
//   }

//   Widget _buildQuoteCard(BuildContext context, Quote quote) {
//     Color statusColor;
//     switch (quote.status) {
//       case 'accepted':
//         statusColor = Colors.green;
//         break;
//       case 'pending':
//         statusColor = Colors.orange;
//         break;
//       default:
//         statusColor = Colors.grey;
//     }

//     return Card(
//       color: Colors.white.withOpacity(0.05),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: ListTile(
//         leading: CircleAvatar(
//           backgroundColor: statusColor.withOpacity(0.2),
//           child: Text(quote.id.substring(0, 2).toUpperCase()),
//         ),
//         title: Text(
//           'Quote #${quote.id}',
//           style: const TextStyle(color: Colors.white),
//         ),
//         subtitle: Text(
//           'Client ID: ${quote.clientId}',
//           style: const TextStyle(color: Colors.white70),
//         ),
//         trailing: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Text(
//               '\$${quote.amount.toStringAsFixed(2)}',
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               decoration: BoxDecoration(
//                 color: statusColor.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Text(
//                 quote.status.toUpperCase(),
//                 style: TextStyle(color: statusColor, fontSize: 10),
//               ),
//             ),
//           ],
//         ),
//         onTap: () {
//           Navigator.pushNamed(context, '/quote-detail', arguments: quote);
//         },
//       ),
//     );
//   }
// }
