import 'package:flutter/material.dart';
import 'package:hackathon/core/colors.dart';
import 'package:hackathon/screens/contract/contract_detail_screen.dart';
import 'package:intl/intl.dart';

class ContractCard extends StatelessWidget {
  final Map<String, dynamic> contract;
  final VoidCallback onUploadPayment;

  const ContractCard({
    super.key,
    required this.contract,
    required this.onUploadPayment,
  });

  int _calculateMonths(String startDate, String endDate) {
    final start = DateFormat('yyyy-MM-dd').parse(startDate);
    final end = DateFormat('yyyy-MM-dd').parse(endDate);
    return (end.year - start.year) * 12 + end.month - start.month;
  }

  String _calculateDaysUntilNextPayment(String nextPaymentDate) {
    final now = DateTime.now();
    final paymentDate = DateFormat('yyyy-MM-dd').parse(nextPaymentDate);
    final difference = paymentDate.difference(now).inDays;
    return difference > 0 ? '$difference kun' : 'Bugun';
  }

  double _calculateTotalAmount() {
    final months = _calculateMonths(contract['start_date'], contract['end_date']);
    return contract['booking_amount'].toDouble() + (contract['monthly_rent'].toDouble() * months);
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'requested':
        return Colors.orange;
      case 'booked':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 500),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ContractDetailScreen(contract: contract),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  AppColors.primaryColor.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Manzil: ${contract['property']['address']}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(contract['status']),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      contract['status'].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Boshlanish: ${contract['start_date']}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  Text(
                    'Tugash: ${contract['end_date']}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Oylik to\'lov: ${NumberFormat.currency(locale: 'uz', symbol: 'so\'m').format(contract['monthly_rent'])}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  Text(
                    'Boshlang\'ich To\'lov: ${NumberFormat.currency(locale: 'uz', symbol: 'so\'m').format(contract['booking_amount'])}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Umumiy Qiymat: ${NumberFormat.currency(locale: 'uz', symbol: 'so\'m').format(_calculateTotalAmount())}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Keyingi To\'lovgacha: ${_calculateDaysUntilNextPayment(contract['next_payment_date'])}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
