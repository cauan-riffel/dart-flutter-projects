import 'dart:io';
import 'dart:math';

void main(List<String> args) {
  late int level;
  print('\n' * 25);
  List<List<int>> bombLocations=[], bandeiras=[];

  level = definirDificuldade(args);
  List<List<String>> campo = criarCampo(level);
  int quantidadeBombas = [10, 40, 99][level];
  mostrarTabuleiro(campo, level, bandeiras, quantidadeBombas, false);
  List<int> jogada = inputJogada(campo, bandeiras, true);
  estilizarCampo(campo, [jogada[0], jogada[1]], bombLocations, level);
  bool perdeu = executar(campo, bombLocations, jogada, true, bandeiras);
  if(jogada[2]==1)quantidadeBombas--;
  else if(jogada[2]==2)quantidadeBombas++;
  while (!perdeu){
    print(campo);
    mostrarTabuleiro(campo, level, bandeiras, quantidadeBombas, false);
    jogada = inputJogada(campo, bandeiras);
    perdeu = executar(campo, bombLocations, jogada, true, bandeiras);
  }
  if(quantidadeBombas!=0){
    int bombas = 0;
    for(List<int>bomba in bombLocations){
      bombas++;
      for(List<int>bandeira in bandeiras){
        if(bomba[0]==bandeira[0]&&bomba[1]==bandeira[1]){
          bombas--;
          break;
        }
      }
    }
    mostrarTabuleiro(campo, level, bandeiras, quantidadeBombas, true);
    print('você perdeu o jogo faltando $bombas pombas!!!!');
  }else{
    print('parabéns, você completou o jogo!!!');
  }
}

int definirDificuldade(List<String> qual) { // ! funcionando
    String? level;
    if(qual.length!=0){
      if (qual[0] == 'easy')return 0;
      else if (qual[0] == 'medium')return 1;
      else if(qual[0] == 'hard') return 2;
      else print('argumento inserido incorretamente!');
    }
    while (level == null || level == 'help') {
      print('digite o nivel que quiser, caso tenha dúvidas digite help.');
      level = stdin.readLineSync();
      if (level == null)
        print('não digite valores núlos.\n\n\n');
      else if (level == 'help') {
        print(
            '\n\n\n\n\n\n\n\n\neasy: campo minado 8x10 com 10 bombas\nmedium: campo minado 16x18 com 40 bombas\nhard: campo minado 20x24 com 99 bombas\n\n');
      } else if (level == 'easy') {
        return 0;
      } else if (level == 'medium') {
        return 1;
      } else if (level == 'hard') {
        return 2;
      } else {
        print(
            '\n\n\n\n\n\n\n\n\nvalor inserido é incorreto, em caso de dúvida digite help.\n\n');
            level = null;
      }
    }
    return 1;
  }

List<List<String>> criarCampo(int level) { // ! funcionando
  List<List<String>> campo = [];
  List<int> tipo = [
    [8, 16, 20][level],
    [10, 18, 24][level]
  ];
  while (tipo[0] != 0) {
    int x = tipo[1];
    List<String> lista = [];
    campo.add(lista);
    while (x != 0) {
      lista.add(' ');
      x--;
    }
    tipo[0]--;
  }
  return campo;
}

void mostrarTabuleiro(List<List<String>> campo, int level, List<List<int>> bandeiras, int quantidadeBombas, bool mostrar) {
  int x = 0;
  print('ainda restam $quantidadeBombas bombas para marcar!');
  stdout.write('   ');
  while (x < campo[0].length) {
    stdout.write(' ${x + 1} ');
    x++;
  }
  print('');
  if(level==0)stdout.write('  +' + '-' * (campo[0].length * 2 + 11) + '+');
  else if(level==1)stdout.write('  +' + '-' * (campo[0].length * 3 + 9) + '+');
  else stdout.write('  +' + '-' * (campo[0].length * 3 + 15) + '+');
  print('');
  int y = 0;
  while (y < campo.length) {
    int x = 0;
    stdout.write('${y + 1}');
    if (y < 9) stdout.write(' ');
    stdout.write('|');
    while (x < campo[y].length) {
      bool temp = false;
      for(List<int> i in bandeiras){
        if(y==i[0]&&x==i[1]) {
          temp = true;
          break;
        }
      }
      if(temp){
        stdout.write(' X ');
      }else if(mostrar)stdout.write(' ${campo[y][x]} ');
      else if(campo[y][x]=='*')stdout.write('   ');
      else{
        stdout.write(' ${campo[y][x]} ');
      }
      if (x >= 9) stdout.write(' ');
      x++;
    }
    print('|${y + 1}');
    y++;
  }
  if(level==0)stdout.write('  +' + '-' * (campo[0].length * 2 + 11) + '+');
  else if(level==1)stdout.write('  +' + '-' * (campo[0].length * 3 + 9) + '+');
  else stdout.write('  +' + '-' * (campo[0].length * 3 + 15) + '+');
  print('');
  y = 0;
  stdout.write('   ');
  while (y < campo[0].length) {
    stdout.write(' ${y + 1} ');
    y++;
  }
  print('');
}

List<int> inputJogada(List<List<String>> camp, List<List<int>>bandeiras,[bool ft = false]) {
  int x, y;
  String? jogada;
  if (ft) {
    jogada = 'abrir';
  } else {
    while (jogada == null || jogada == 'help') {
      print('qual jogada deseja realizar?');
      jogada = stdin.readLineSync();
      if (jogada == 'abrir' ||
          jogada == 'bandeira' ||
          jogada == 'tirar bandeira') {
        break;
      } else if (jogada == 'help') {
        print(
            '\n\nabrir: irá abrir o terreno e caso o local selecionado seja uma bomba, você perde\nbandeira: colocorá uma bandeira no campo que irá evitar que o jogador abra o terreno onde estiver uma bandeira\ntirar bandeira: irá retirar uma bandeira que o jogador selecionará.\n\n');
      } else {
        print('Você digitou o comando errado, por favor tente novamente');
        jogada=null;
      }
    }
  }
  while(true){
    print('Digite o numero da linha que você realizará a sua jogada!!');
    String? tempY = stdin.readLineSync();
    while (tempY == null || int.tryParse(tempY) == null || int.parse(tempY) < 0 || int.parse(tempY) > camp.length) {
      print('jogada inválida! Favor jogar novamente');
      tempY = stdin.readLineSync();
    }
    y = int.parse(tempY)-1;
    print('Digite o numero da coluna que você realizará a sua jogada!!');
    String? tempX = stdin.readLineSync();
    while (tempX == null || int.tryParse(tempX) == null || int.parse(tempX) < 0 || int.parse(tempX) > camp[0].length) {
      print('jogada inválida! Favor jogar novamente');
      tempX = stdin.readLineSync();
    }
    x = int.parse(tempX)-1;
    bool emBandeira = false;
    for(List<int>bandeira in bandeiras){
      if(bandeira[0]==y&&bandeira[1]==x){
        emBandeira = true;
        break;
      }
    }
    if(jogada=='abrir'){
      if((camp[y][x]==' '||camp[y][x]=='*')&&!emBandeira){
        return [y, x, 0];
      }else{
        print('jogada inválida!!!');
        continue;
      }
    }else if(jogada=='bandeira'){
      if(camp[y][x]==' '||camp[y][x]=='*'&&!emBandeira){
        return [y, x, 1];
      }else{
        print('jogada inválida!!!');
        continue;
      }
    }else{
      print(bandeiras);
      if(bandeiras.length==0){
        print('não existe bandeiras no tabuleiro!!!');
        return inputJogada(camp, bandeiras);
      }
      if(emBandeira){
        return [y, x, 2];
      }else{
        print('jogada inválida!!!');
        continue;
      }
    }
  }
}

void estilizarCampo(List<List<String>> camp, List<int> excecao, List<List<int>> bombLocations, int level){ //!FUNFIANDO
  int bombs = [10, 40, 99][level];
  while(bombs!=0){
    int y=Random().nextInt(camp.length), x=Random().nextInt(camp[0].length);
    while(excecao[0]==y && excecao[1]==x || camp[y][x]=='*'){
      y=Random().nextInt(camp.length);
      x=Random().nextInt(camp[0].length);
    }
    camp[y][x]='*';
    bombLocations.add([y, x]);
    bombs--;
  }
}

bool executar(List<List<String>>campo, List<List<int>>bombs, List<int> jogada, bool player, List<List<int>>bandeiras, [int? bombasAnterior]){
  int y=jogada[0], x=jogada[1];
  if(jogada[2]==1){
    bandeiras.add([y, x]);
    return false;
  }else if(jogada[2]==2){
    campo[y][x] = ' ';
    int temp = 0;
    print(bandeiras.length);
    for(List<int>bandeira in bandeiras){
      print(bandeira);
      if(bandeira[0]==y&&bandeira[1]==x){
        break;
      }
      temp++;
    }
    bandeiras.removeAt(temp);
    return false;
  }else{
    if(player)for(List<int> bomba in bombs){
      if(y==bomba[0]&&x==bomba[1])return true;
    }
    int bombasRedor = 0;
    for(List<int> locais in [[y-1, x-1],[y-1, x],[y-1, x+1],[y, x-1],[y, x+1],[y+1, x-1],[y+1, x],[y+1, x+1]]){
      int yI=locais[0];
      int xI=locais[1];
      if(xI<0||yI<0||xI>=campo[0].length||yI>=campo.length){
        continue;
      }else{
        for(List<int>bomba in bombs){
          if(bomba[0]==yI&&bomba[1]==xI){
            bombasRedor++;
          }
        }
      }
    }
    if(player||bombasRedor==0||bombasAnterior==0){
      if(player)bombasAnterior=bombasRedor;
      campo[y][x]='$bombasRedor';
      if(bombasRedor==0&&(bombasAnterior==0||player))for(List<int> locais in [[y-1, x-1],[y-1, x],[y-1, x+1],[y, x-1],[y, x+1],[y+1, x-1],[y+1, x],[y+1, x+1]]){
        int yI=locais[0];
        int xI=locais[1];
        if(xI<0||yI<0||xI>=campo[0].length||yI>=campo.length||campo[yI][xI]!=' '){
          continue;
        }else{
          print('x:$xI. y:$yI');
          mostrarTabuleiro(campo, 0, bandeiras, 10, true);
          executar(campo, bombs, [yI, xI, 0], false, bandeiras, bombasAnterior);
        }
      }
    }
  }
  return false;
}
