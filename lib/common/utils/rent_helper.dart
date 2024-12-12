class RentHelper {
  static double calculatePrice(DateTime? selectedDate, double monthlyPrice) {
    if(selectedDate== null)
      {
        return 0;
      }
    DateTime currentDate = DateTime.now();
    currentDate = DateTime(currentDate.year, currentDate.month, currentDate.day);
    selectedDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    int daysDifference = selectedDate.difference(currentDate).inDays;
    if (daysDifference <= 0) {
      return 0.0;
    }
    double dailyPrice = monthlyPrice / 30;
    return daysDifference * dailyPrice;
  }
}
