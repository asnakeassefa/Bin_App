import 'package:flutter/material.dart';

class CustomForm extends StatefulWidget {
  final String? name;
  final String? label;
  const CustomForm(
      {super.key,
      required this.name,
      required this.label,
      required this.nameCont,
      required this.labelCont});
  final TextEditingController? labelCont;
  final TextEditingController? nameCont;

  @override
  State<CustomForm> createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${widget.name} *",
                    style: const TextStyle(
                      fontSize: 16,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: TextField(
                    controller: widget.nameCont,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: '${widget.name} ',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 1,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                //   SizedBox(height: 15),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${widget.label} *",
                  style: const TextStyle(
                    fontSize: 16,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.4,
                child: TextField(
                  controller: widget.labelCont,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 1,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2,
                      ),
                    ),
                    hintText: '${widget.label} ',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              //   SizedBox(height: 15),
            ],
          ),
        ],
      ),
    );
  }
}
