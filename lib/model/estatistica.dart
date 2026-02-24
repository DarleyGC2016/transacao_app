class Estatistica {
  late int _count;
  late double _sum;
  late double _avg;
  late double _min;
  late double _max;

  int get count => _count;

  double get avg => _avg;

  double get sum => _sum;

  double get getMax => _max;

  double get getMin => _min;

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
  }){
     _count = contador;
     _sum = soma;
     _avg = media;
     _min = minimo;
     _max = maximo;
   }

  factory Estatistica.fromJson(Map<String, dynamic> json) {
     return Estatistica(
        contador: (json['count']),
        soma: (json['sum'] as num).toDouble(),
        media: (json['avg'] as num).toDouble(),
        minimo: (json['min'] as num).toDouble(),
        maximo: (json['max'] as num).toDouble());
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