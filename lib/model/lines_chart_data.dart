class ChartData{
  ChartData({String date, double sbp, double dbp, int dateint}):
  _date = date,
  _sbp = sbp,
  _dbp = dbp,
  _dateint = dateint
  ;
  final String _date;
  final int _dateint;
  final double _sbp;
  final double _dbp;

  int getDateInt(){return _dateint;}
  String getDate(){return _date;}
  double getSBP(){return _sbp;}
  double getDBP(){return _dbp;}
  
}