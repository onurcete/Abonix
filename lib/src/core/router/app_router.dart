import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/subscriptions/presentation/add_edit_subscription_screen.dart';
import '../../features/subscriptions/presentation/home_screen.dart';
import '../../features/subscriptions/presentation/subscription_detail_screen.dart';

final appRouterProvider = Provider<GoRouter>(
  (ref) => GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/add',
        builder: (context, state) => const AddEditSubscriptionScreen(),
      ),
      GoRoute(
        path: '/edit/:id',
        builder: (context, state) =>
            AddEditSubscriptionScreen(subscriptionId: state.pathParameters['id']),
      ),
      GoRoute(
        path: '/detail/:id',
        builder: (context, state) =>
            SubscriptionDetailScreen(subscriptionId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  ),
);
