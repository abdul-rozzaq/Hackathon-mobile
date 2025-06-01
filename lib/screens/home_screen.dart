import 'package:flutter/material.dart';
import 'package:hackathon/core/colors.dart';
import 'package:hackathon/providers/app_provider.dart';
import 'package:hackathon/screens/contract/contract_list_screen.dart';
import 'package:hackathon/screens/profile_screen.dart';
import 'package:hackathon/screens/properties/properties_list_screen.dart';
import 'package:hackathon/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const PropertiesListScreen(),
    const ContractStatusScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();

    context.read<AppProvider>().fetchProperties();
  }

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Mulkly App',
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Uylar'),
          BottomNavigationBarItem(icon: Icon(Icons.description), label: 'Shartnomalar'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
