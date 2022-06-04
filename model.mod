int sretangles = 2; // Número de peças a serem cortadas
range m = 1..sretangles; // A0 será cortada em m pedaços menores

int L0=100; // Length of rectangle A0
int W0=100; // width of rectangle A0

//Orientação de cortes de peças em relação ao A0 
range L = 0..L0-1; // Possíveis posições inferior-esquerda para o vértice de corte para retângulos menores em relação a largura
range W = 0..W0-1; // Posições correspondentes em relação ao comprimento

//parâmetros
int l[m]=[15, 15]; // Largura do retângulo recortado i
int w[m]=[50, 90]; // Comprimento do retângulo recortado i
int v[m]=[20, 35]; // Valor do retângulo recortado i

int Q[m]= [4, 4]; //Número mínimo de cortes do tipo i que podem ser cortado de A0
int P[m]= [0, 0]; //Número máximo de cortes do tipo i que podem ser cortado de A0
int a[i in m][p in L][q in W][r in L][s in W]; //Contém 1 se o corte do tipo i será feito, caso contrário contém 0

execute calculate_a{
  for (var i in m )
    for (var p in L)
      for (var q in W)
        for(var r in L)
          for (var s in W)
            if (0 <= p && p <= r && r <= ((p+l[i])-1) && ((p+l[i])-1) <= (L0-1) && 0<=q && q <= s && s <= ((q+w[i])-1) && ((q+w[i])-1) <= (W0-1)){
              a[i][p][q][r][s] = 1;
            } else {
              a[i][p][q][r][s] = 0;
            }
}

//Variáveis de decisão
//Se a peça anterior é cortada
dvar boolean x[i in m][p in L][q in W];

//Função objetivo
maximize
sum(i in m, p in L, q in W : 0 <= p && p <= (L0 - l[i]) && 0 <= q && q <= (W0-w[i])) v[i]*x[i][p][q];

//Restrições
subject to{
  rest1:
    forall(r in L, s in W)
      sum(i in m, p in L, q in W: 0 <= p && p <= (L0-l[i]) && 0 <= q && q <= (W0-w[i])) a[i][p][q][r][s]*x[i][p][q] <= 1;
  rest2:
    forall(i in m){
      sum(p in L, q in W) x[i][p][q] >= P[i];
      sum(p in L, q in W) x[i][p][q] <= Q[i];
    }
}
