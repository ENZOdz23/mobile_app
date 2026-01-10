class StatisticsModel {
  final double totalRevenue;
  final int totalContacts;
  final int totalProspects;
  final int interestedProspects;
  final int notInterestedProspects;
  final int activeOffers;
  final List<double> monthlyRevenue;
  final double growthRate;

  StatisticsModel({
    required this.totalRevenue,
    required this.totalContacts,
    required this.totalProspects,
    required this.interestedProspects,
    required this.notInterestedProspects,
    required this.activeOffers,
    required this.monthlyRevenue,
    required this.growthRate,
  });

  factory StatisticsModel.initial() {
    return StatisticsModel(
      totalRevenue: 0,
      totalContacts: 0,
      totalProspects: 0,
      interestedProspects: 0,
      notInterestedProspects: 0,
      activeOffers: 0,
      monthlyRevenue: List.filled(6, 0.0),
      growthRate: 0,
    );
  }
}
