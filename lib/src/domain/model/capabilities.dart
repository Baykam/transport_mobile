class Capabilities {
  final bool canCreateLoad;
  final bool canAcceptLoad;
  final bool canAssignDriver;
  final bool canManageDocuments;
  final bool canVerifyUsers;
  final bool canTrackAll;
  final bool canAccessAnalytics;
  final bool canReceivePayouts;

  const Capabilities({
    this.canCreateLoad = false,
    this.canAcceptLoad = false,
    this.canAssignDriver = false,
    this.canManageDocuments = false,
    this.canVerifyUsers = false,
    this.canTrackAll = false,
    this.canAccessAnalytics = false,
    this.canReceivePayouts = false,
  });
}