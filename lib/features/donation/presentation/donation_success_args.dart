class DonationSuccessArgs {
  final double amount;
  final int? returnToTabIndex;
  final String? projectTitle;

  const DonationSuccessArgs({
    required this.amount,
    this.returnToTabIndex,
    this.projectTitle,
  });
}
