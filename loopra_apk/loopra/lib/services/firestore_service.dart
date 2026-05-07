import '../models/waste_item.dart';
import '../models/collection_point.dart';
import '../models/marketplace_listing.dart';
import '../models/carbon_data.dart';
import '../models/pickup_schedule.dart';
import '../models/wallet_transaction.dart';

class FirestoreService {
  // Mock data for hackathon MVP
  final List<WasteItem> _mockWasteItems = [];
  final List<WalletTransaction> _mockTransactions = [];

  // Waste Items
  Future<List<WasteItem>> getWasteItems(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockWasteItems.where((item) => item.userId == userId).toList();
  }

  Future<WasteItem> addWasteItem(WasteItem item) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockWasteItems.add(item);
    return item;
  }

  // Collection Points
  Future<List<CollectionPoint>> getCollectionPoints() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      CollectionPoint(
        id: 'cp_001',
        name: 'Pasar Induk Berasagi',
        type: 'Market Hub',
        latitude: -6.2088,
        longitude: 106.8456,
        address: 'Jl. Raya Berasagi No. 123, Jakarta',
        phone: '021-1234567',
        operatingHours: '04:00 - 18:00',
        currentCapacity: 650.0,
        maxCapacity: 1000.0,
      ),
      CollectionPoint(
        id: 'cp_002',
        name: 'Agro Collection Center',
        type: 'Farm Collection',
        latitude: -6.2500,
        longitude: 106.7800,
        address: 'Jl. Pertanian No. 45, Depok',
        phone: '021-7654321',
        operatingHours: '06:00 - 16:00',
        currentCapacity: 320.0,
        maxCapacity: 500.0,
      ),
      CollectionPoint(
        id: 'cp_003',
        name: 'Mobile Unit Alpha',
        type: 'Mobile Unit',
        latitude: -6.3000,
        longitude: 106.8200,
        address: 'Rotating - Bogor Area',
        phone: '0812-9876543',
        operatingHours: '08:00 - 14:00',
        currentCapacity: 150.0,
        maxCapacity: 300.0,
      ),
    ];
  }

  // Marketplace Listings
  Future<List<MarketplaceListing>> getMarketplaceListings() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      MarketplaceListing(
        id: 'ml_001',
        industryId: 'ind_001',
        industryName: 'Bioenergy Nusantara',
        wasteType: 'fruit',
        processType: 'Bioethanol',
        quantityNeeded: 500.0,
        pricePerKg: 1800.0,
        description: 'Seeking overripe bananas and mangoes for bioethanol production. Minimum 100kg per delivery.',
        status: 'open',
        deadline: DateTime.now().add(const Duration(days: 14)),
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      MarketplaceListing(
        id: 'ml_002',
        industryId: 'ind_002',
        industryName: 'GreenGas Industries',
        wasteType: 'mixed',
        processType: 'Biogas',
        quantityNeeded: 1000.0,
        pricePerKg: 1200.0,
        description: 'Mixed organic waste for biogas anaerobic digestion. All conditions accepted.',
        status: 'open',
        deadline: DateTime.now().add(const Duration(days: 21)),
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      MarketplaceListing(
        id: 'ml_003',
        industryId: 'ind_003',
        industryName: 'EcoFuel Solutions',
        wasteType: 'vegetable',
        processType: 'Bioethanol',
        quantityNeeded: 300.0,
        pricePerKg: 1500.0,
        description: 'Tomatoes and leafy greens for experimental bioethanol process.',
        status: 'open',
        deadline: DateTime.now().add(const Duration(days: 7)),
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  // Carbon Data
  Future<List<CarbonData>> getCarbonData(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      CarbonData(
        id: 'cd_001',
        userId: userId,
        date: DateTime.now().subtract(const Duration(days: 30)),
        methanePreventedKg: 12.5,
        carbonCreditsEarned: 2.1,
        totalWasteProcessedKg: 150.0,
        energyGeneratedKwh: 75.0,
      ),
      CarbonData(
        id: 'cd_002',
        userId: userId,
        date: DateTime.now().subtract(const Duration(days: 23)),
        methanePreventedKg: 8.3,
        carbonCreditsEarned: 1.4,
        totalWasteProcessedKg: 100.0,
        energyGeneratedKwh: 50.0,
      ),
      CarbonData(
        id: 'cd_003',
        userId: userId,
        date: DateTime.now().subtract(const Duration(days: 16)),
        methanePreventedKg: 15.7,
        carbonCreditsEarned: 2.6,
        totalWasteProcessedKg: 200.0,
        energyGeneratedKwh: 100.0,
      ),
      CarbonData(
        id: 'cd_004',
        userId: userId,
        date: DateTime.now().subtract(const Duration(days: 9)),
        methanePreventedKg: 9.0,
        carbonCreditsEarned: 1.5,
        totalWasteProcessedKg: 110.0,
        energyGeneratedKwh: 55.0,
      ),
    ];
  }

  // Pickup Schedules
  Future<List<PickupSchedule>> getPickupSchedules(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      PickupSchedule(
        id: 'ps_001',
        userId: userId,
        scheduledDate: DateTime.now().add(const Duration(days: 1)),
        collectionPointId: 'cp_001',
        collectionPointName: 'Pasar Induk Berasagi',
        status: 'scheduled',
        estimatedWeightKg: 45.0,
        truckType: 'Pickup Truck',
        driverName: 'Pak Slamet',
        driverPhone: '0812-3456-7890',
      ),
      PickupSchedule(
        id: 'ps_002',
        userId: userId,
        scheduledDate: DateTime.now().add(const Duration(days: 4)),
        collectionPointId: 'cp_002',
        collectionPointName: 'Agro Collection Center',
        status: 'scheduled',
        estimatedWeightKg: 120.0,
        truckType: 'Box Truck',
        driverName: 'Pak Joko',
        driverPhone: '0813-4567-8901',
      ),
      PickupSchedule(
        id: 'ps_003',
        userId: userId,
        scheduledDate: DateTime.now().subtract(const Duration(days: 3)),
        collectionPointId: 'cp_001',
        collectionPointName: 'Pasar Induk Berasagi',
        status: 'completed',
        estimatedWeightKg: 60.0,
        truckType: 'Pickup Truck',
        driverName: 'Pak Slamet',
        driverPhone: '0812-3456-7890',
      ),
    ];
  }

  // Wallet Transactions
  Future<List<WalletTransaction>> getWalletTransactions(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (_mockTransactions.isEmpty) {
      return [
        WalletTransaction(
          id: 'wt_001',
          userId: userId,
          amount: 67500.0,
          type: 'credit',
          category: 'waste_sale',
          description: 'Banana waste - 45kg',
          wasteItemId: 'wi_001',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        WalletTransaction(
          id: 'wt_002',
          userId: userId,
          amount: 120000.0,
          type: 'credit',
          category: 'waste_sale',
          description: 'Mixed vegetables - 80kg',
          wasteItemId: 'wi_002',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
        WalletTransaction(
          id: 'wt_003',
          userId: userId,
          amount: 50000.0,
          type: 'credit',
          category: 'bonus',
          description: 'Weekly participation bonus',
          createdAt: DateTime.now().subtract(const Duration(days: 7)),
        ),
        WalletTransaction(
          id: 'wt_004',
          userId: userId,
          amount: 250000.0,
          type: 'debit',
          category: 'withdrawal',
          description: 'Withdrawal to Bank BCA',
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
        ),
      ];
    }
    return _mockTransactions.where((t) => t.userId == userId).toList();
  }

  Future<WalletTransaction> addWalletTransaction(WalletTransaction transaction) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockTransactions.add(transaction);
    return transaction;
  }
}
