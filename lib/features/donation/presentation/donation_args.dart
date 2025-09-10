class DonationArgs {
  final String projectTitle;
  final double? presetAmount;
  final int? returnToTabIndex; // which bottom tab to restore on back (0=Home,1=Search,...)

  const DonationArgs({
    required this.projectTitle,
    this.presetAmount,
    this.returnToTabIndex,
  });
}
