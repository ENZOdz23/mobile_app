import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:crm_sales_performance_mobilis/features/contacts/presentation/cubits/add_contact_cubit.dart';
import 'package:crm_sales_performance_mobilis/features/contacts/presentation/cubits/add_contact_state.dart';
import 'package:crm_sales_performance_mobilis/features/contacts/domain/add_contact_use_case.dart';
import 'package:crm_sales_performance_mobilis/features/contacts/models/contact.dart';

@GenerateMocks([AddContactUseCase])
import 'add_contact_cubit_test.mocks.dart';

void main() {
  late AddContactCubit cubit;
  late MockAddContactUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockAddContactUseCase();
    cubit = AddContactCubit(mockUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  group('AddContactCubit Tests', () {
    final contact = Contact(
      id: '1',
      name: 'Ala Mezdoud',
      phoneNumber: '0555123456',
      email: 'ala@example.com',
    );

    blocTest<AddContactCubit, AddContactState>(
      'emits [AddContactLoading, AddContactSuccess] when contact is added successfully',
      build: () {
        when(mockUseCase.call(any)).thenAnswer((_) async => {});
        return cubit;
      },
      act: (cubit) => cubit.addContact(contact),
      expect: () => [isA<AddContactLoading>(), isA<AddContactSuccess>()],
    );

    blocTest<AddContactCubit, AddContactState>(
      'emits [AddContactLoading, AddContactFailure] when adding contact fails',
      build: () {
        when(mockUseCase.call(any)).thenThrow(Exception('Failed'));
        return cubit;
      },
      act: (cubit) => cubit.addContact(contact),
      expect: () => [isA<AddContactLoading>(), isA<AddContactFailure>()],
    );
  });
}
