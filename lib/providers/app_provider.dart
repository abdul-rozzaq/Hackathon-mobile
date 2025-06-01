import 'package:flutter/material.dart';
import 'package:hackathon/models/property.dart';
import 'package:hackathon/models/user.dart';
import 'package:hackathon/services/api_service.dart';

class AppProvider extends ChangeNotifier {
  late User user;

  final ApiService apiService = ApiService();

  List<Property> baseProperties = [];
  List<Property> properties = [];
  String searchQuery = '';
  String filterStatus = 'all';
  bool sortByPriceAscending = true;

  Future<void> fetchProperties() async {
    try {
      final fetchedProperties = await apiService.fetchProperties();
      baseProperties = fetchedProperties;

      _filterAndSortProperties();

      notifyListeners();
    } catch (e) {
      print('Xatolik: $e');
    }
  }

  void _filterAndSortProperties() {
    var filteredProperties = baseProperties;

    if (filterStatus != 'all') {
      filteredProperties = filteredProperties.where((property) => property.status == filterStatus).toList();
    }

    if (searchQuery.isNotEmpty) {
      filteredProperties = filteredProperties.where((property) => property.name.toLowerCase().contains(searchQuery.toLowerCase())).toList();
    }

    filteredProperties.sort((a, b) {
      final aPrice = a.floors.expand((floor) => floor.apartments).map((apartment) => apartment.price).reduce((a, b) => a < b ? a : b);
      final bPrice = b.floors.expand((floor) => floor.apartments).map((apartment) => apartment.price).reduce((a, b) => a < b ? a : b);
      return sortByPriceAscending ? aPrice.compareTo(bPrice) : bPrice.compareTo(aPrice);
    });

    properties = filteredProperties;
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    searchQuery = query;
    _filterAndSortProperties();
  }

  void updateFilterStatus(String status) {
    filterStatus = status;
    _filterAndSortProperties();
  }

  void toggleSortByPrice() {
    sortByPriceAscending = !sortByPriceAscending;
    _filterAndSortProperties();
  }

  // User

  Future<bool> checkAuth() async {
    User? user = await apiService.checkAuth();

    if (user != null) {
      this.user = user;

      return true;
    }
    return false;
  }

  Future login(username, password) async {
    try {
      user = await apiService.login(username, password);

      return true;
    } catch (e) {
      print('Login xatosi: $e');
      return false;
    }
  }
}
