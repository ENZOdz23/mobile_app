# Contacts Feature - Cubit Quick Reference

## How to Use the Cubits

### 1. ContactsCubit

#### Load contacts
```dart
context.read<ContactsCubit>().loadContacts();
```

#### Update a contact
```dart
final updatedContact = contact.copyWith(name: 'New Name');
context.read<ContactsCubit>().updateContact(updatedContact);
```

#### Delete a contact
```dart
context.read<ContactsCubit>().deleteContact(contactId);
```

#### Get interlocuteurs for a prospect
```dart
final contactsCubit = context.read<ContactsCubit>();
final interlocuteurs = contactsCubit.getInterlocuteursForProspect('Company Name');
```

#### Listen to state changes
```dart
BlocBuilder<ContactsCubit, ContactsState>(
  builder: (context, state) {
    if (state is ContactsLoading) {
      return CircularProgressIndicator();
    } else if (state is ContactsLoaded) {
      final contacts = state.contacts;
      return ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) => ContactItem(contact: contacts[index]),
      );
    } else if (state is ContactsError) {
      return Text('Error: ${state.message}');
    }
    return SizedBox.shrink();
  },
)
```

### 2. ProspectsCubit

#### Load prospects
```dart
context.read<ProspectsCubit>().loadProspects();
```

#### Update a prospect
```dart
final updatedProspect = prospect.copyWith(status: ProspectStatus.interested);
context.read<ProspectsCubit>().updateProspect(updatedProspect);
```

#### Delete a prospect
```dart
context.read<ProspectsCubit>().deleteProspect(prospectId);
```

#### Convert prospect to client
```dart
context.read<ProspectsCubit>().convertProspectToClient(prospectId);
```

#### Listen to state changes
```dart
BlocBuilder<ProspectsCubit, ProspectsState>(
  builder: (context, state) {
    if (state is ProspectsLoading) {
      return CircularProgressIndicator();
    } else if (state is ProspectsLoaded) {
      final prospects = state.prospects;
      return ListView.builder(
        itemCount: prospects.length,
        itemBuilder: (context, index) => ProspectItem(prospect: prospects[index]),
      );
    } else if (state is ProspectsError) {
      return Text('Error: ${state.message}');
    }
    return SizedBox.shrink();
  },
)
```

### 3. ContactsListCubit

#### Change tab
```dart
context.read<ContactsListCubit>().changeTab(ContactType.client);
// or
context.read<ContactsListCubit>().changeTab(ContactType.prospect);
```

#### Get current tab
```dart
final currentTab = context.read<ContactsListCubit>().selectedType;
```

#### Listen to tab changes
```dart
BlocBuilder<ContactsListCubit, ContactsListState>(
  builder: (context, state) {
    final cubit = context.read<ContactsListCubit>();
    final selectedType = cubit.selectedType;
    
    return selectedType == ContactType.client
        ? ClientsListView()
        : ProspectsListView();
  },
)
```

## Providing Cubits

### Single Screen
```dart
BlocProvider(
  create: (context) => ContactsCubit(
    getContactsUseCase: getContactsUseCase,
    contactsRepository: contactRepository,
  )..loadContacts(),
  child: MyScreen(),
)
```

### Multiple Cubits
```dart
MultiBlocProvider(
  providers: [
    BlocProvider(
      create: (context) => ContactsCubit(
        getContactsUseCase: getContactsUseCase,
        contactsRepository: contactRepository,
      )..loadContacts(),
    ),
    BlocProvider(
      create: (context) => ProspectsCubit(
        getProspectsUseCase: getProspectsUseCase,
        prospectRepository: prospectRepository,
      )..loadProspects(),
    ),
    BlocProvider(
      create: (context) => ContactsListCubit(),
    ),
  ],
  child: ContactsListScreen(),
)
```

### Passing Cubit to Child Screen
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => BlocProvider.value(
      value: context.read<ContactsCubit>(),
      child: ContactFormScreen(contact: contact),
    ),
  ),
);
```

## State Classes Reference

### ContactsState
- `ContactsInitial` - Initial state before any data is loaded
- `ContactsLoading` - Currently loading contacts
- `ContactsLoaded(List<Contact> contacts)` - Contacts loaded successfully
- `ContactsError(String message)` - Error occurred while loading/updating

### ProspectsState
- `ProspectsInitial` - Initial state before any data is loaded
- `ProspectsLoading` - Currently loading prospects
- `ProspectsLoaded(List<Prospect> prospects)` - Prospects loaded successfully
- `ProspectsError(String message)` - Error occurred while loading/updating

### ContactsListState
- `ContactsListInitial` - Initial state
- `ContactsListTabChanged(ContactType selectedType)` - Tab selection changed

## Best Practices

1. **Always load data on cubit creation**
   ```dart
   create: (context) => ContactsCubit(...)..loadContacts(),
   ```

2. **Use BlocBuilder for UI updates**
   - Don't manually call setState
   - Let BlocBuilder handle rebuilds

3. **Use context.read() for actions**
   ```dart
   onPressed: () => context.read<ContactsCubit>().deleteContact(id),
   ```

4. **Use context.watch() only when needed**
   - Prefer BlocBuilder for most cases
   - Use context.watch() sparingly in build methods

5. **Handle all state cases**
   - Always handle Loading, Loaded, Error states
   - Provide fallback UI for Initial state

6. **Pass cubits to child screens when needed**
   ```dart
   BlocProvider.value(
     value: context.read<ContactsCubit>(),
     child: ChildScreen(),
   )
   ```

## Common Patterns

### Refresh Data
```dart
onRefresh: () async {
  context.read<ContactsCubit>().loadContacts();
  // Wait for state to change
  await Future.delayed(Duration(milliseconds: 500));
},
```

### Show Loading Indicator
```dart
BlocBuilder<ContactsCubit, ContactsState>(
  builder: (context, state) {
    if (state is ContactsLoading) {
      return Center(child: CircularProgressIndicator());
    }
    // ... rest of UI
  },
)
```

### Show Error Message
```dart
BlocListener<ContactsCubit, ContactsState>(
  listener: (context, state) {
    if (state is ContactsError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
  child: MyWidget(),
)
```

### Combine BlocBuilder and BlocListener
```dart
BlocConsumer<ContactsCubit, ContactsState>(
  listener: (context, state) {
    if (state is ContactsError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
  builder: (context, state) {
    if (state is ContactsLoaded) {
      return ListView(children: state.contacts.map(...));
    }
    return CircularProgressIndicator();
  },
)
```
