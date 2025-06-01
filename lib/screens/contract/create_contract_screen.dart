import 'package:flutter/material.dart';
import 'package:hackathon/models/apartment.dart';
import 'package:hackathon/screens/contract/contract_list_screen.dart';
import 'package:intl/intl.dart';

class CreateContractScreen extends StatefulWidget {
  final Apartment apartment;

  const CreateContractScreen({super.key, required this.apartment});

  @override
  CreateContractScreenState createState() => CreateContractScreenState();
}

class CreateContractScreenState extends State<CreateContractScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _initialAmountController = TextEditingController();
  final _passportController = TextEditingController();

  String _selectedDuration = '6';
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<String> _durations = List.generate(10, (index) => (6 + index * 6).toString());

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _initialAmountController.dispose();
    _passportController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildCleanTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    VoidCallback? onTap,
    String? Function(String?)? validator,
    bool isPassword = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: isPassword,
          style: const TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText: label,
            hintStyle: const TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 15,
            ),
            prefixIcon: Icon(
              icon,
              color: const Color(0xFF6B7280),
              size: 20,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            errorStyle: const TextStyle(
              fontSize: 12,
              color: Color(0xFFEF4444),
            ),
          ),
          enabled: onTap == null,
          readOnly: onTap != null,
          validator: validator,
        ),
      ),
    );
  }

  Widget _buildCleanDropdown() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedDuration,
            dropdownColor: Colors.white,
            items: _durations.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  '$value oy',
                  style: const TextStyle(
                    color: Color(0xFF1F2937),
                    fontSize: 16,
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedDuration = newValue!;
                _calculateEndDate();
              });
            },
            isExpanded: true,
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF6B7280),
              size: 24,
            ),
            hint: const Text(
              'Muddat tanlang',
              style: TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 15,
              ),
            ),
            selectedItemBuilder: (BuildContext context) {
              return _durations.map<Widget>((String value) {
                return Row(
                  children: [
                    const Icon(
                      Icons.schedule,
                      color: Color(0xFF6B7280),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '$value oy',
                      style: const TextStyle(
                        color: Color(0xFF1F2937),
                        fontSize: 16,
                      ),
                    ),
                  ],
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPriceInfo(String title, String price, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF64748B),
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: const TextStyle(
                    color: Color(0xFF1E293B),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _calculateEndDate() {
    if (_startDateController.text.isNotEmpty) {
      final startDate = DateFormat('yyyy-MM-dd').parse(_startDateController.text);
      final durationMonths = int.parse(_selectedDuration);

      int newYear = startDate.year + (startDate.month + durationMonths - 1) ~/ 12;
      int newMonth = (startDate.month + durationMonths - 1) % 12 + 1;
      int newDay = startDate.day;

      DateTime endDate;
      try {
        endDate = DateTime(newYear, newMonth, newDay);
      } catch (e) {
        endDate = DateTime(newYear, newMonth + 1, 0);
      }

      _endDateController.text = DateFormat('yyyy-MM-dd').format(endDate);
    }
  }

  void _createContract() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      Future.delayed(const Duration(seconds: 2), () {
        setState(() => _isLoading = false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ContractStatusScreen()),
        );
      });
    }
  }

  double getOneMothPrice() {
    return (widget.apartment.price - (int.tryParse(_initialAmountController.text) ?? 0)) / int.parse(_selectedDuration);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1F2937)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Shartnoma Yaratish',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: const Color(0xFFE5E7EB),
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                _buildCleanTextField(
                  controller: _startDateController,
                  label: 'Boshlanish Sanasi',
                  icon: Icons.calendar_today,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2026),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Color(0xFF3B82F6),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (date != null) {
                      _startDateController.text = DateFormat('yyyy-MM-dd').format(date);
                      _calculateEndDate();
                    }
                  },
                  validator: (value) => value?.isEmpty ?? true ? 'Iltimos, sanani tanlang' : null,
                ),

                _buildCleanTextField(
                  controller: _endDateController,
                  label: 'Tugash Sanasi',
                  icon: Icons.event,
                  validator: (value) => value?.isEmpty ?? true ? 'Iltimos, sanani ko\'rsating' : null,
                ),

                _buildCleanDropdown(),

                _buildCleanTextField(
                  controller: _initialAmountController,
                  label: 'Boshlang\'ich Summa (so\'m)',
                  icon: Icons.account_balance_wallet,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Iltimos, summani kiriting';
                    final amount = double.tryParse(value!.replaceAll(',', '')) ?? 0.0;
                    return amount < 3000000 ? 'Eng kamda 3,000,000 so\'m bo\'lishi kerak' : null;
                  },
                ),

                _buildCleanTextField(
                  controller: _passportController,
                  label: 'Passport (AB1234567)',
                  icon: Icons.credit_card,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Iltimos, passportni kiriting';
                    final regex = RegExp(r'^[A-Za-z]{2}\d{7}$');
                    return regex.hasMatch(value!) ? null : 'Format: 2 harf + 7 raqam (masalan, AB1234567)';
                  },
                ),

                const SizedBox(height: 24),

                // Price Information
                _buildPriceInfo(
                  'Umumiy Narx',
                  '${widget.apartment.price} so\'m',
                  Icons.home,
                ),

                _buildPriceInfo(
                  'Bir oyga',
                  '${getOneMothPrice().toStringAsFixed(2)} so\'m',
                  Icons.calendar_month,
                ),

                const SizedBox(height: 32),

                // Submit Button
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF3B82F6),
                          strokeWidth: 2,
                        ),
                      )
                    : SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _createContract,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B82F6),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Shartnoma Yuborish',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
