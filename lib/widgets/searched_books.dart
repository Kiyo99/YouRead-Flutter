import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:k_books/presentation/screens/books/summary_screen.dart';

class SearchedBooks extends HookWidget {
  const SearchedBooks(this.data, {Key? key}) : super(key: key);

  final List<Map<String, dynamic>?>? data;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: data!.length,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 10);
      },
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          visualDensity: const VisualDensity(horizontal: -4, vertical: -2.5),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 25,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                data![index]!['url'],
                width: double.maxFinite,
                fit: BoxFit.cover,
                // width: 180,
              ),
            ),
          ),
          title: Text(
            data![index]!['title'],
            style: GoogleFonts.nunito(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            data![index]!['author'],
            style: GoogleFonts.nunito(color: Colors.black),
          ),
          onTap: () {
            Get.toNamed(SummaryScreen.id, arguments: data![index]);
          },
          trailing: const Icon(Icons.arrow_forward_ios_outlined),
        );
      },
    );

    // return SizedBox(
    //   height: 250,
    //   child: ListView.builder(
    //     physics: const BouncingScrollPhysics(),
    //     scrollDirection: Axis.horizontal,
    //     shrinkWrap: true,
    //     itemCount: data!.length,
    //     itemBuilder: (BuildContext context, int index) {
    //       return GestureDetector(
    //         onTap: () {
    //           Get.toNamed(SummaryScreen.id, arguments: data![index]);
    //         },
    //         child: Column(
    //           children: [
    //             SizedBox(
    //               width: 150,
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Center(
    //                     child: ClipRRect(
    //                       borderRadius: BorderRadius.circular(10),
    //                       child: Image.network(
    //                         data![index]!['url'],
    //                         height: 180,
    //                         // width: 180,
    //                       ),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             const SizedBox(height: 10),
    //             Text(
    //               data![index]!['title'],
    //               style: GoogleFonts.nunito(
    //                   color: Colors.black,
    //                   fontSize: 16,
    //                   fontWeight: FontWeight.bold),
    //             ),
    //             const SizedBox(height: 10),
    //             Text(
    //               data![index]!['author'],
    //               style: GoogleFonts.nunito(color: Colors.black, fontSize: 14),
    //             ),
    //           ],
    //         ),
    //       );
    //     },
    //   ),
    // );
  }
}
