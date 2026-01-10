import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:crm_sales_performance_mobilis/features/offres/data/offer_repository.dart';
import 'package:crm_sales_performance_mobilis/features/offres/data/offres_local_data_source.dart';
import 'package:crm_sales_performance_mobilis/features/offres/models/offer_model.dart';

@GenerateMocks([OffresLocalDataSource])
import 'offer_repository_test.mocks.dart';

void main() {
  late OfferRepository repository;
  late MockOffresLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockOffresLocalDataSource();
    repository = OfferRepository(localDataSource: mockLocalDataSource);
  });

  group('OfferRepository Tests', () {
    final tOffer = OfferModel(
      id: '1',
      title: 'Test Offer',
      shortDescription: 'Short',
      fullDescription: 'Full',
      keyBenefit: 'Benefit',
      startingPrice: '1000',
      currency: 'DZD',
      targetCompanyType: CompanyType.enterprise,
      includedServices: ['Service 1'],
      category: 'Test',
      icon: 'test_icon',
    );

    test('should return list of offers from local data source', () async {
      // Arrange
      when(mockLocalDataSource.fetchOffers()).thenAnswer((_) async => [tOffer]);

      // Act
      final result = await repository.fetchOffers();

      // Assert
      expect(result, [tOffer]);
      verify(mockLocalDataSource.fetchOffers()).called(1);
    });

    test('should return offer by id', () async {
      // Arrange
      when(
        mockLocalDataSource.fetchOfferById('1'),
      ).thenAnswer((_) async => tOffer);

      // Act
      final result = await repository.fetchOfferById('1');

      // Assert
      expect(result, tOffer);
      verify(mockLocalDataSource.fetchOfferById('1')).called(1);
    });

    test('should call initializeData successfully', () async {
      // Arrange
      when(mockLocalDataSource.seedInitialData()).thenAnswer((_) async => {});

      // Act
      await repository.initializeData();

      // Assert
      verify(mockLocalDataSource.seedInitialData()).called(1);
    });
  });
}
