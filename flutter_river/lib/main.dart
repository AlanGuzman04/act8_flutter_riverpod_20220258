import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
   runApp(
     const ProviderScope(
       child: MyApp(),
     ),
   );
}

class Product{
  Product({required this.name, required this.price});

  final String name;
  final double price;
}

final _products = [
  Product(name: "Tortas Cubanas", price: 55),
  Product(name: "Tacos", price: 20),
  Product(name: "Hot dog", price: 25),
  Product(name: "Carnita asada", price: 125),
  Product(name: "Chocomilk", price: 27),
  Product(name: "Pizzahambuerguesa", price: 80),
];

enum ProductSortType{
  name,
  delaz,
  price,
  menor,
}



//This is the default sort type when the app is run
final productSortTypeProvider = StateProvider<ProductSortType>((ref) => 
ProductSortType.name);


final futureProductsProvider = FutureProvider<List<Product>>((ref) async {
  await Future.delayed(const Duration(seconds: 3));
  final sortType = ref.watch(productSortTypeProvider);
switch (sortType) {
    case ProductSortType.name:
       _products.sort((a, b) => a.name.compareTo(b.name));
       break;
    case ProductSortType.delaz:
       _products.sort((b, a) => a.name.compareTo(b.name));
       break;
    case ProductSortType.price:
       _products.sort((a, b) => a.price.compareTo(b.price));
       
    case ProductSortType.menor:
       _products.sort((b, a) => a.price.compareTo(b.price));
}
  return _products;
});



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  

  // This widget is the root of your application.

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 136, 19, 169)),
        useMaterial3: true,
      ),
      home: const ProductPage(),
    );
  }
}






class ProductPage extends ConsumerWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final productsProvider = ref.watch(futureProductsProvider);



    productsProvider.when(
        data: (products)=> ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index){
              return Padding(
                padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
                child: Card(
                  color: Colors.blueAccent,
                  elevation: 3,
                  child: ListTile(
                    title: Text(products[index].name,style: const TextStyle(
                        color: Colors.white,  fontSize: 15)),
                    subtitle: Text("${products[index].price}",style: const TextStyle(
                        color: Colors.white,  fontSize: 15)),
                  ),
                ),
              );
            }),
        error: (err, stack) => Text("Error: $err",style: const TextStyle(
            color: Colors.white,  fontSize: 15)),
        loading: ()=> const Center(child: CircularProgressIndicator(color: Colors.white,)),
    );



    

    return Scaffold(
        appBar: AppBar(
          title: const Text("Carrito comida"),
          actions: [
            DropdownButton<ProductSortType>(
              dropdownColor: const Color.fromARGB(255, 192, 180, 176),
              value: ref.watch(productSortTypeProvider),
                items: const [
                  DropdownMenuItem(
                    value: ProductSortType.name,
                    child: Icon(Icons.sort_by_alpha),
                ),
                DropdownMenuItem(
                    value: ProductSortType.delaz,
                    child: Icon(Icons.sort_by_alpha_rounded),
                ),
                  DropdownMenuItem(
                    value: ProductSortType.price,
                    child: Icon(Icons.south_rounded),
                  ),
                DropdownMenuItem(
                    value: ProductSortType.menor,
                    child: Icon(Icons.sort_sharp),
                ),
                ],
                onChanged: (value)=> ref.watch(productSortTypeProvider.notifier).state = value!
            ),
          ],
        ),
      backgroundColor: const Color.fromARGB(255, 244, 3, 192),
      body: Container(
        child: productsProvider.when(
            data: (products)=> ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index){
                  return Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
                    child: Card(
                      color: const Color.fromARGB(255, 94, 9, 173),
                      elevation: 3,
                      child: ListTile(
                        title: Text(products[index].name,style: const TextStyle(
                            color: Colors.white,  fontSize: 15)),
                        subtitle: Text("${products[index].price}",style: const TextStyle(
                            color: Colors.white,  fontSize: 15)),
                      ),
                    ),
                  );
                }),
            error: (err, stack) => Text("Error: $err",style: const TextStyle(
                color: Colors.white,  fontSize: 15)),
            loading: ()=> const Center(child: CircularProgressIndicator(color: Colors.white,)),
        ),
      )
    );
  }
}
