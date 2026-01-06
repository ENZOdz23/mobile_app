// lib/features/home/presentation/cubit/activities_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../models/activity.dart';
import '../../../../core/api/api_client.dart';

abstract class ActivitiesState {}

class ActivitiesInitial extends ActivitiesState {}

class ActivitiesLoading extends ActivitiesState {}

class ActivitiesLoaded extends ActivitiesState {
  final List<Activity> activities;

  ActivitiesLoaded(this.activities);
}

class ActivitiesError extends ActivitiesState {
  final String message;

  ActivitiesError(this.message);
}

class ActivitiesCubit extends Cubit<ActivitiesState> {
  final Dio _dio;

  ActivitiesCubit({Dio? dio}) 
      : _dio = dio ?? Api.getDio(),
        super(ActivitiesInitial());

  Future<void> loadActivities() async {
    try {
      emit(ActivitiesLoading());
      final response = await _dio.get('/activities/');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = response.data is List
            ? response.data
            : (response.data as Map)['results'] ?? [];

        final activities = data
            .map((item) => Activity.fromJson(item as Map<String, dynamic>))
            .toList();

        // Sort by timestamp (most recent first)
        activities.sort((a, b) => b.timestamp.compareTo(a.timestamp));

        emit(ActivitiesLoaded(activities));
      } else {
        emit(ActivitiesError('Failed to load activities: ${response.statusCode}'));
      }
    } catch (e) {
      emit(ActivitiesError('Failed to load activities: ${e.toString()}'));
    }
  }

  Future<void> refreshActivities() async {
    await loadActivities();
  }
}

