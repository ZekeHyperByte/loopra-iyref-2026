import 'package:flutter/material.dart';

class WasteSubmission {
  final String id;
  final String sellerName;
  final String wasteType;
  final String specificType;
  final String condition;
  final String grade;
  final String recommendedProcess;
  final double weightKg;
  final double estimatedValuePerKg;
  double finalPricePerKg;
  double get estimatedTotal => weightKg * estimatedValuePerKg;
  double get finalTotal => weightKg * finalPricePerKg;
  String status;
  final DateTime createdAt;

  WasteSubmission({
    required this.id,
    required this.sellerName,
    required this.wasteType,
    required this.specificType,
    required this.condition,
    required this.grade,
    required this.recommendedProcess,
    required this.weightKg,
    required this.estimatedValuePerKg,
    this.finalPricePerKg = 0,
    this.status = 'pending_verification',
    required this.createdAt,
  });

  Map<String, dynamic> toQRData() {
    return {
      'submissionId': id,
      'amount': finalTotal.toStringAsFixed(0),
      'seller': sellerName,
      'type': specificType,
    };
  }
}

class PickupRequest {
  final String id;
  final String collectionPointName;
  final String collectionPointAddress;
  double estimatedWeightKg;
  String status;
  String? driverName;
  String? driverPhone;
  final DateTime createdAt;
  DateTime? scheduledDate;
  DateTime? arrivedAt;
  DateTime? departedAt;

  PickupRequest({
    required this.id,
    required this.collectionPointName,
    required this.collectionPointAddress,
    required this.estimatedWeightKg,
    this.status = 'requested',
    this.driverName,
    this.driverPhone,
    required this.createdAt,
    this.scheduledDate,
    this.arrivedAt,
    this.departedAt,
  });
}

class DeliveryOrder {
  final String id;
  final String buyerName;
  final String buyerAddress;
  final String wasteType;
  final double weightKg;
  String status;
  final DateTime estimatedArrival;
  final DateTime createdAt;

  DeliveryOrder({
    required this.id,
    required this.buyerName,
    required this.buyerAddress,
    required this.wasteType,
    required this.weightKg,
    this.status = 'preparing',
    required this.estimatedArrival,
    required this.createdAt,
  });
}

class DemoState extends ChangeNotifier {
  static final DemoState _instance = DemoState._internal();
  factory DemoState() => _instance;
  DemoState._internal() {
    _initializeDummyData();
  }

  double sellerBalance = 1250000;
  double collectionPointCapacity = 715;
  double collectionPointMaxCapacity = 1000;
  double get capacityPercent => collectionPointCapacity / collectionPointMaxCapacity;

  final List<WasteSubmission> _submissions = [];
  final List<PickupRequest> _pickupRequests = [];
  final List<DeliveryOrder> _deliveryOrders = [];

  List<WasteSubmission> get submissions => List.unmodifiable(_submissions);
  List<WasteSubmission> get pendingSubmissions =>
      _submissions.where((s) => s.status == 'pending_verification').toList();
  List<WasteSubmission> get verifiedSubmissions =>
      _submissions.where((s) => s.status == 'verified').toList();
  List<WasteSubmission> get paidSubmissions =>
      _submissions.where((s) => s.status == 'paid').toList();
  List<PickupRequest> get pickupRequests => List.unmodifiable(_pickupRequests);
  List<PickupRequest> get activePickups =>
      _pickupRequests.where((p) => p.status != 'delivered').toList();
  List<DeliveryOrder> get deliveryOrders => List.unmodifiable(_deliveryOrders);

  WasteSubmission? currentSellerSubmission;
  String? lastQRCode;

  void _initializeDummyData() {
    // --- Seller Ahmad's story ---
    // Submission 1: Paid (already completed)
    final submission1 = WasteSubmission(
      id: 'WS001',
      sellerName: 'Ahmad Suryadi',
      wasteType: 'fruit',
      specificType: 'Jeruk',
      condition: 'Overripe',
      grade: 'A',
      recommendedProcess: 'Bioethanol',
      weightKg: 25.0,
      estimatedValuePerKg: 2500.0,
      finalPricePerKg: 2500.0,
      status: 'paid',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    );

    // Submission 2: Pending verification (current live one)
    final submission2 = WasteSubmission(
      id: 'WS002',
      sellerName: 'Ahmad Suryadi',
      wasteType: 'fruit',
      specificType: 'Pisang',
      condition: 'Overripe',
      grade: 'A',
      recommendedProcess: 'Bioethanol',
      weightKg: 30.0,
      estimatedValuePerKg: 2200.0,
      finalPricePerKg: 0,
      status: 'pending_verification',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    );

    // Submission 3: Another pending from Budi
    final submission3 = WasteSubmission(
      id: 'WS003',
      sellerName: 'Budi Santoso',
      wasteType: 'fruit',
      specificType: 'Mangga',
      condition: 'Light Rot',
      grade: 'B',
      recommendedProcess: 'Bioethanol',
      weightKg: 40.0,
      estimatedValuePerKg: 1800.0,
      finalPricePerKg: 0,
      status: 'pending_verification',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    );

    // Submission 4: Verified, waiting for QR scan
    final submission4 = WasteSubmission(
      id: 'WS004',
      sellerName: 'Citra Dewi',
      wasteType: 'vegetable',
      specificType: 'Kangkung',
      condition: 'Heavy Rot',
      grade: 'C',
      recommendedProcess: 'Biogas',
      weightKg: 50.0,
      estimatedValuePerKg: 600.0,
      finalPricePerKg: 650.0,
      status: 'verified',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    );

    _submissions.addAll([submission1, submission2, submission3, submission4]);
    currentSellerSubmission = submission2;

    // --- Pickup story ---
    // Pickup 1: At Bank Sampah Inyong, requested, driver can start
    final pickup1 = PickupRequest(
      id: 'PU001',
      collectionPointName: 'Bank Sampah Inyong',
      collectionPointAddress: 'Jl. Green Loop No. 42, Yogyakarta',
      estimatedWeightKg: 325.0,
      status: 'requested',
      driverName: 'Pak Slamet',
      driverPhone: '0812-3456-7890',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      scheduledDate: DateTime.now().add(const Duration(hours: 2)),
    );

    // Pickup 2: At Agro Collection Center, loading, driver can depart
    final pickup2 = PickupRequest(
      id: 'PU002',
      collectionPointName: 'Agro Collection Center',
      collectionPointAddress: 'Jl. Pertanian No. 45, Depok',
      estimatedWeightKg: 280.0,
      status: 'loading',
      driverName: 'Pak Slamet',
      driverPhone: '0812-3456-7890',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      scheduledDate: DateTime.now().subtract(const Duration(hours: 4)),
      arrivedAt: DateTime.now().subtract(const Duration(hours: 2)),
    );

    // Pickup 3: Departed (in transit to buyer)
    final pickup3 = PickupRequest(
      id: 'PU003',
      collectionPointName: 'Pasar Induk Berasagi',
      collectionPointAddress: 'Jl. Raya Berasagi No. 123, Jakarta',
      estimatedWeightKg: 150.0,
      status: 'departed',
      driverName: 'Pak Joko',
      driverPhone: '0813-4567-8901',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      scheduledDate: DateTime.now().subtract(const Duration(days: 2)),
      arrivedAt: DateTime.now().subtract(const Duration(days: 2)),
      departedAt: DateTime.now().subtract(const Duration(hours: 6)),
    );

    _pickupRequests.addAll([pickup1, pickup2, pickup3]);

    // --- Delivery orders ---
    final delivery1 = DeliveryOrder(
      id: 'DO001',
      buyerName: 'PT Pertamina (Persero)',
      buyerAddress: 'Jl. Medan Merdeka Timur No. 1, Jakarta',
      wasteType: 'Mixed Organic',
      weightKg: 280.0,
      status: 'in_transit',
      estimatedArrival: DateTime.now().add(const Duration(hours: 3)),
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    );

    final delivery2 = DeliveryOrder(
      id: 'DO002',
      buyerName: 'Bioenergy Nusantara',
      buyerAddress: 'Jl. Industri Bio No. 88, Bekasi',
      wasteType: 'Fruit Waste',
      weightKg: 150.0,
      status: 'delivered',
      estimatedArrival: DateTime.now().subtract(const Duration(hours: 2)),
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    );

    _deliveryOrders.addAll([delivery1, delivery2]);
  }

  void addSubmission(WasteSubmission submission) {
    _submissions.insert(0, submission);
    currentSellerSubmission = submission;
    collectionPointCapacity += submission.weightKg;
    notifyListeners();
  }

  void verifySubmission(String submissionId, double finalPricePerKg) {
    final index = _submissions.indexWhere((s) => s.id == submissionId);
    if (index != -1) {
      _submissions[index].finalPricePerKg = finalPricePerKg;
      _submissions[index].status = 'verified';
      lastQRCode = submissionId;
      notifyListeners();
    }
  }

  void markAsPaid(String submissionId) {
    final index = _submissions.indexWhere((s) => s.id == submissionId);
    if (index != -1) {
      final submission = _submissions[index];
      _submissions[index].status = 'paid';
      sellerBalance += submission.finalTotal;
      notifyListeners();
    }
  }

  void requestPickup(String collectionPointName, String address) {
    final pickup = PickupRequest(
      id: 'PU${DateTime.now().millisecondsSinceEpoch}',
      collectionPointName: collectionPointName,
      collectionPointAddress: address,
      estimatedWeightKg: collectionPointCapacity,
      status: 'requested',
      driverName: 'Pak Slamet',
      driverPhone: '0812-3456-7890',
      createdAt: DateTime.now(),
      scheduledDate: DateTime.now().add(const Duration(hours: 2)),
    );
    _pickupRequests.insert(0, pickup);
    notifyListeners();
  }

  void assignDriver(String pickupId) {
    final index = _pickupRequests.indexWhere((p) => p.id == pickupId);
    if (index != -1) {
      _pickupRequests[index].status = 'in_transit';
      notifyListeners();
    }
  }

  void confirmTruckArrived(String pickupId) {
    final index = _pickupRequests.indexWhere((p) => p.id == pickupId);
    if (index != -1) {
      _pickupRequests[index].status = 'loading';
      _pickupRequests[index].arrivedAt = DateTime.now();
      notifyListeners();
    }
  }

  void confirmTruckDeparted(String pickupId) {
    final index = _pickupRequests.indexWhere((p) => p.id == pickupId);
    if (index != -1) {
      _pickupRequests[index].status = 'departed';
      _pickupRequests[index].departedAt = DateTime.now();
      collectionPointCapacity = 0;
      _addDeliveryOrder(_pickupRequests[index]);
      notifyListeners();
    }
  }

  void markDelivered(String pickupId) {
    final index = _pickupRequests.indexWhere((p) => p.id == pickupId);
    if (index != -1) {
      _pickupRequests[index].status = 'delivered';
      notifyListeners();
    }
  }

  void _addDeliveryOrder(PickupRequest pickup) {
    final delivery = DeliveryOrder(
      id: 'DO${DateTime.now().millisecondsSinceEpoch}',
      buyerName: 'PT Pertamina (Persero)',
      buyerAddress: 'Jl. Medan Merdeka Timur No. 1, Jakarta',
      wasteType: 'Mixed Organic',
      weightKg: pickup.estimatedWeightKg,
      status: 'in_transit',
      estimatedArrival: DateTime.now().add(const Duration(hours: 3)),
      createdAt: DateTime.now(),
    );
    _deliveryOrders.insert(0, delivery);
    notifyListeners();
  }

  void advanceDeliveryStatus(String deliveryId) {
    final index = _deliveryOrders.indexWhere((d) => d.id == deliveryId);
    if (index != -1) {
      final order = _deliveryOrders[index];
      if (order.status == 'preparing') {
        _deliveryOrders[index].status = 'in_transit';
      } else if (order.status == 'in_transit') {
        _deliveryOrders[index].status = 'delivered';
      }
      notifyListeners();
    }
  }

  void reset() {
    _submissions.clear();
    _pickupRequests.clear();
    _deliveryOrders.clear();
    sellerBalance = 1250000;
    collectionPointCapacity = 650;
    currentSellerSubmission = null;
    lastQRCode = null;
    _initializeDummyData();
    notifyListeners();
  }
}
