import 'package:flutter/material.dart';
import 'package:hackathon/core/colors.dart';
import 'package:hackathon/providers/app_provider.dart';
import 'package:hackathon/widgets/custom_property_card.dart';
import 'package:provider/provider.dart';

class PropertiesListScreen extends StatefulWidget {
  const PropertiesListScreen({super.key});

  @override
  PropertiesListScreenState createState() => PropertiesListScreenState();
}

class PropertiesListScreenState extends State<PropertiesListScreen> {
  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => appProvider.fetchProperties(),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Qidiruv',
                    prefixIcon: Icon(Icons.search, color: AppColors.primaryColor),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primaryColor, width: 1.2),
                    ),
                  ),
                  onChanged: (value) {
                    appProvider.updateSearchQuery(value);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Filtr Dropdown
                    DropdownButton<String>(
                      value: appProvider.filterStatus,
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('Barchasi')),
                        DropdownMenuItem(value: 'completed', child: Text('Tugallangan')),
                        DropdownMenuItem(value: 'under_construction', child: Text('Qurilmoqda')),
                        DropdownMenuItem(value: 'planned', child: Text('Rejalashtirilgan')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          appProvider.updateFilterStatus(value);
                        }
                      },
                      underline: Container(
                        height: 2,
                        color: AppColors.primaryColor,
                      ),
                      icon: const Icon(Icons.filter_list, color: AppColors.primaryColor),
                    ),
                    // Saralash tugmasi
                    IconButton(
                      icon: Icon(
                        appProvider.sortByPriceAscending ? Icons.arrow_upward : Icons.arrow_downward,
                        color: AppColors.primaryColor,
                      ),
                      onPressed: () {
                        appProvider.toggleSortByPrice();
                      },
                      tooltip: 'Narx bo\'yicha saralash',
                    ),
                  ],
                ),
              ),
              // Property ro'yxati
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: appProvider.properties.length,
                itemBuilder: (context, index) {
                  final property = appProvider.properties[index];
                  return CustomPropertyCard(property: property);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
