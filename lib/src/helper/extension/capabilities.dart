import 'package:transport/src/domain/model/capabilities.dart';
import 'package:transport/src/helper/enum/UserRole.dart';

Capabilities resolveCapabilities(UserRole role) {
  switch (role) {
    case UserRole.customer:
      return const Capabilities(
        canCreateLoad: true,
      );

    case UserRole.driver:
      return const Capabilities(
        canAcceptLoad: true,
        canReceivePayouts: true,
      );

    case UserRole.broker:
      return const Capabilities(
        canCreateLoad: true,
        canManageDocuments: true,
        canAssignDriver: true,
        canTrackAll: true,
        canReceivePayouts: true,
        canAccessAnalytics: true,
      );

    case UserRole.documentAgent:
      return const Capabilities(
        canManageDocuments: true,
      );

    case UserRole.admin:
      return const Capabilities(
        canVerifyUsers: true,
        canTrackAll: true,
        canAccessAnalytics: true,
      );
  }
}