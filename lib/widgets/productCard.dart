import 'package:flutter/material.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:provider/provider.dart';
import 'package:yebelo/Provider/CartProvider.dart';
import 'package:yebelo/module/testIem.dart';

class ProductCard extends StatefulWidget {
  final TestItem item;

  const ProductCard({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int itemCount = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(
                  width: 1, color: Color.fromRGBO(6, 33, 125, 1))),
          color: const Color.fromARGB(255, 255, 255, 255),
          margin: const EdgeInsets.fromLTRB(5, 5, 5, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 2,
              ),
              FittedBox(
                child: Image.asset('assets/images/orange.jpg'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.item.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Flexible(
                    child: Container(
                  width: 100,
                  child: Text(
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                      '${widget.item.details}'),
                )),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹ ${widget.item.cost}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    SizedBox(
                      height: 40,
                      width: 100,
                      child: Chip(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        label: Text(widget.item.category,
                            style: TextStyle(fontSize: 12)),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 120.0,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (itemCount == 0 &&
                                widget.item.availability != 0) {
                              itemCount = 1;
                              context
                                  .read<CartProvider>()
                                  .updateItemCount(widget.item.id, itemCount);
                            } else {
                              itemCount = (itemCount + 1) %
                                  (widget.item.availability + 1);
                            }
                          });
                          context
                              .read<CartProvider>()
                              .updateItemCount(widget.item.id, itemCount);
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              width: 2, color: Color.fromRGBO(6, 33, 125, 1)),
                          primary: itemCount > 0 ? Colors.white : Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        child: (itemCount > 0 && widget.item.availability != 0)
                            ? InputQty(
                                maxVal: widget.item.availability,
                                initVal: 0,
                                minVal: 0,
                                steps: 1,
                                onQtyChanged: (val) {
                                  context
                                      .read<CartProvider>()
                                      .updateItemCount(widget.item.id, val);
                                  setState(() {
                                    itemCount = val;
                                  });
                                },
                              )
                            : Text('Add to Cart',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
