
class Estatistica {
  late int _count;
  late double _sum;
  late double _avg;
  late double _min;
  late double _max;
  late String _time;
  late String _date;
  late List<double> _values;

  int get count => _count;

  double get avg => _avg;

  double get sum => _sum;

  double get max => _max;

  double get min => _min;

  String get time => _time;

  String get date => _date;

  List<double> get values => _values;

   set setCount( int contador){
    _count = contador;
  }
  set setAvg(double avg){
    _avg = avg;
  }

  set setSum(double vSum){
    _sum = vSum;
  }

  set setMax (double nMax){
    _max = nMax;
  }

  set setMin (double nMin){
    _min = nMin;
  }

   Estatistica({
    required int contador,
    required double soma,
    required double media,
    required double minimo,
    required double maximo,
    required String tempo,
    required String data,
    required List<double> valor
  }){
     _count = contador;
     _sum = soma;
     _avg = media;
     _min = minimo;
      _max = maximo;
     _time = tempo ;
     _date = data;
     _values = valor;
   }

  factory Estatistica.fromJson(Map<String, dynamic> json) {
     return Estatistica(
        contador: (json['count']),
        soma: (json['sum'] as num).toDouble(),
        media: (json['avg'] as num).toDouble(),
        minimo: (json['min'] as num).toDouble(),
        maximo: (json['max'] as num).toDouble(),
        tempo: (json['time'] as String),
        data:  (json['date'] as String),
        valor:(json['values'] as List<dynamic>)
         .map((e) => (e as num).toDouble())
         .toList()
     );

  }

  void sendError(String error){
       throw Exception(error);
  }

  @override
  String toString() {
    return 'count: $_count'
        ', _sum: $_sum,'
        ' _avg: $_avg,'
        ' _min: $_min,'
        ' _max: $_max}';
  }




}