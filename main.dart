import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RandomNumberPassword(),
    );
  }
}

class RandomNumberPassword extends StatefulWidget {
  const RandomNumberPassword({super.key});

  @override
  State<RandomNumberPassword> createState() => _RandomNumberPasswordState();
}

class _RandomNumberPasswordState extends State<RandomNumberPassword> {
  final senhaController = TextEditingController();
  final controllerCPF = TextEditingController();
  List<List<int>> lstSenhaController = [];

  @override
  Widget build(BuildContext context) {
    Size windowSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        //CPF
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: TextField(
              controller: controllerCPF,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                labelText: 'DIGITE SEU CPF',
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400)),
              ),
            ),
          ),
        ),

        //Senha
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: TextField(
              obscureText: true,
              controller: senhaController,
              showCursor: true,
              readOnly: true,
              onTap: () async {
                await getModalRandomNumericPassword();
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                labelText: 'SENHA',
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400)),
              ),
            ),
          ),
        ),

        //Botao
        Padding(
          padding: const EdgeInsets.only(
            top: 30,
            bottom: 15,
          ),
          child: InkWell(
            onTap: () async {
              controllerCPF.text = controllerCPF.text.trim();
              senhaController.text = senhaController.text.trim();

              if (controllerCPF.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Informe o CPF.")));
              } else if (senhaController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Informe a senha.")));
              } else {
                List<Map> lstSenhas = [];
                for (List<int> cada in lstSenhaController) {
                  Map senha = {};
                  senha = {
                    "opcao1": cada[0],
                    "opcao2": cada[1],
                  };
                  lstSenhas.add(senha);
                }

                String mapToSend = '''
                  {
                    "login":"${controllerCPF.text}",
                    "senha": ${lstSenhas.toString()}
                  }                                              
                ''';
                print(mapToSend);
                // String retorno = await Controller.postLogin(mapToSend);
                //   if (retorno == 'true') {
                //     // your code
                //   } else {
                //     //your code
                //   }
              }
            },
            child: Container(
              height: 50,
              width: windowSize.width * 0.7,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(255, 140, 65, 1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Center(
                child: Text(
                  'Entrar',
                  style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Future<void> getModalRandomNumericPassword() async {
    List<List<int>> lstNumberPairs = getNumberPairs();

    await showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.white,
        barrierColor: Colors.transparent,
        elevation: 5,
        builder: (BuildContext bc) {
          return Wrap(children: <Widget>[
            ListView.builder(
              padding: const EdgeInsets.only(bottom: 20),
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.close_rounded,
                              size: 30,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 40, mainAxisSpacing: 40),
                        padding: const EdgeInsets.only(right: 40, bottom: 40, left: 40),
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: lstNumberPairs.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          return (index <= lstNumberPairs.length - 1
                              ? InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (lstSenhaController.length < 6) {
                                        lstSenhaController.add(lstNumberPairs[index]);
                                        senhaController.text = '${senhaController.text}*';
                                      }
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${lstNumberPairs[index][0]} ou ${lstNumberPairs[index][1]}',
                                      style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (lstSenhaController.isNotEmpty) {
                                        lstSenhaController.removeLast();
                                        senhaController.text = senhaController.text.substring(0, senhaController.text.length - 1);
                                      }
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.backspace_outlined,
                                      size: 30,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ));
                        }),
                  ],
                );
              },
            ),
          ]);
        });
  }

  List<List<int>> getNumberPairs() {
    List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0];
    numbers.shuffle();
    print(numbers);
    List<List<int>> lstNumberPairs = [];
    List<int> eachPairs = [];

    for (int index = 0; index < numbers.length; index++) {
      if (eachPairs.length == 2) {
        lstNumberPairs.add(List.from(eachPairs));
        eachPairs.clear();
        eachPairs.add(numbers[index]);
      } else {
        eachPairs.add(numbers[index]);
        if (index == 9) lstNumberPairs.add(List.from(eachPairs));
      }
    }
    return lstNumberPairs;
  }
}
