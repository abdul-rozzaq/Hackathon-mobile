import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hackathon/core/colors.dart';
import 'package:hackathon/widgets/contract_card.dart';
// import 'package:file_picker/file_picker.dart';

class ContractStatusScreen extends StatefulWidget {
  const ContractStatusScreen({super.key});

  @override
  ContractStatusScreenState createState() => ContractStatusScreenState();
}

class ContractStatusScreenState extends State<ContractStatusScreen> {
  bool _isLoading = true;

  final List<Map<String, dynamic>> contracts = [
    {
      'id': 1,
      'property': {
        'id': 1,
        'address': 'Toshkent, Yunusobod, 45-uy',
      },
      'status': 'requested',
      'start_date': '2025-06-01',
      'end_date': '2026-06-01',
      'monthly_rent': 1500000,
      'booking_amount': 5000000,
      'next_payment_date': '2025-07-01', // Keyingi to'lov sanasi
    },
    {
      'id': 2,
      'property': {
        'id': 2,
        'address': 'Toshkent, Chilanzar, 12-uy',
      },
      'status': 'booked',
      'start_date': '2025-07-01',
      'end_date': '2026-07-01',
      'monthly_rent': 1200000,
      'booking_amount': 4000000,
      'next_payment_date': '2025-08-01', // Keyingi to'lov sanasi
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchContracts();
  }

  Future<void> _fetchContracts() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1)); // API simulyatsiyasi
    setState(() => _isLoading = false);
    // Haqiqiy API so'rovi:
    // final response = await http.get(Uri.parse('http://your-django-api/api/contracts/?tenant=1'));
    // if (response.statusCode == 200) {
    //   setState(() {
    //     contracts = jsonDecode(response.body);
    //     _isLoading = false;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor.withOpacity(0.01),
            Colors.white,
          ],
        ),
      ),
      child: _isLoading
          ? const Center(
              child: SpinKitFadingCircle(
                color: AppColors.primaryColor,
                size: 50,
              ),
            )
          : contracts.isEmpty
              ? const Center(
                  child: Text(
                    'Shartnomalar topilmadi',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: contracts.length,
                  itemBuilder: (context, index) {
                    return ContractCard(
                      contract: contracts[index],
                      onUploadPayment: () => _showPaymentDialog(contracts[index]['id']),
                    );
                  },
                ),
    );
  }

  Future<void> _showPaymentDialog(int contractId) async {
    final amountController = TextEditingController();
    final filePath = ValueNotifier<String?>(null);
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'To\'lov Yuklash',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryColor),
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: amountController,
                decoration: InputDecoration(
                  labelText: 'Summa (so\'m)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.attach_money, color: AppColors.primaryColor),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Iltimos, summani kiriting';
                  final amount = double.tryParse(value!) ?? 0.0;
                  return amount <= 0 ? 'Summa 0 dan katta bo‘lishi kerak' : null;
                },
              ),
              const SizedBox(height: 10),
              ValueListenableBuilder<String?>(
                valueListenable: filePath,
                builder: (context, value, child) {
                  return Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          // final result = await FilePicker.platform.pickFiles(
                          //   type: FileType.custom,
                          //   allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
                          // );
                          // if (result != null && result.files.isNotEmpty) {
                          //   filePath.value = result.files.first.path;
                          // }
                        },
                        icon: const Icon(Icons.upload_file),
                        label: const Text('Chekni Tanlash'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      if (value != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Tanlangan: ${value.split('/').last}',
                            style: const TextStyle(color: Colors.green),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Bekor qilish', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate() && filePath.value != null) {
                // To'lovni API orqali yuborish
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('To‘lov muvaffaqiyatli yuklandi')),
                );
                Navigator.pop(context);
              } else if (filePath.value == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Iltimos, chekni tanlang')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Yuklash'),
          ),
        ],
      ),
    );
  }
}

// class ContractCard extends StatelessWidget {
//   final Map<String, dynamic> contract;
//   final VoidCallback onUploadPayment;

//   const ContractCard({
//     super.key,
//     required this.contract,
//     required this.onUploadPayment,
//   });

//   int _calculateMonths(String startDate, String endDate) {
//     final start = DateFormat('yyyy-MM-dd').parse(startDate);
//     final end = DateFormat('yyyy-MM-dd').parse(endDate);
//     return (end.year - start.year) * 12 + end.month - start.month;
//   }

//   String _calculateDaysUntilNextPayment(String nextPaymentDate) {
//     final now = DateTime.now();
//     final paymentDate = DateFormat('yyyy-MM-dd').parse(nextPaymentDate);
//     final difference = paymentDate.difference(now).inDays;
//     return difference > 0 ? '$difference kun' : 'Bugun';
//   }

//   double _calculateTotalAmount() {
//     final months = _calculateMonths(contract['start_date'], contract['end_date']);

//     return contract['booking_amount'].toDouble() + (contract['monthly_rent'].toDouble() * months);
//   }

//   Color _getStatusColor(String status) {
//     switch (status) {
//       case 'requested':
//         return Colors.orange;
//       case 'booked':
//         return Colors.green;
//       default:
//         return Colors.grey;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedOpacity(
//       opacity: 1.0,
//       duration: const Duration(milliseconds: 500),
//       child: Card(
//         elevation: 5,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         margin: const EdgeInsets.symmetric(vertical: 8.0),
//         child: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Colors.white,
//                 AppColors.primaryColor.withOpacity(0.05),
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Manzil: ${contract['property']['address']}',
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF1F2937),
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: _getStatusColor(contract['status']),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     contract['status'].toUpperCase(),
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Boshlanish: ${contract['start_date']}',
//                   style: TextStyle(fontSize: 14, color: Colors.grey[700]),
//                 ),
//                 Text(
//                   'Tugash: ${contract['end_date']}',
//                   style: TextStyle(fontSize: 14, color: Colors.grey[700]),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Oylik to\'lov: ${NumberFormat.currency(locale: 'uz', symbol: 'so\'m').format(contract['monthly_rent'])}',
//                   style: TextStyle(fontSize: 14, color: Colors.grey[700]),
//                 ),
//                 Text(
//                   'Boshlang\'ich To\'lov: ${NumberFormat.currency(locale: 'uz', symbol: 'so\'m').format(contract['booking_amount'])}',
//                   style: TextStyle(fontSize: 14, color: Colors.grey[700]),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Umumiy Qiymat: ${NumberFormat.currency(locale: 'uz', symbol: 'so\'m').format(_calculateTotalAmount())}',
//                   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Keyingi To\'lovgacha: ${_calculateDaysUntilNextPayment(contract['next_payment_date'])}',
//                       style: TextStyle(fontSize: 14, color: Colors.grey[700]),
//                     ),
//                     ElevatedButton(
//                       onPressed: onUploadPayment,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.primaryColor,
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: const Text('To\'lov Yuklash'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
