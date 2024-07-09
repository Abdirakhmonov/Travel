import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lesson_72/services/travel_service.dart';
import '../../model/travel_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Travel",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showAddLocationDialog(context);
            },
            icon: const Icon(Icons.add),
          ),
        ],
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: TravelService().getTravels(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: Text("Not data"),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Error... ${snapshot.hasError}"),
            );
          }
          final data = snapshot.data!.docs;
          return GridView.builder(
            itemCount: data.length,
            padding: const EdgeInsets.all(15),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              mainAxisExtent: 295,
            ),
            itemBuilder: (context, index) {
              final travel = Travel.fromJson(data[index]);
              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      height: 180,
                      width: 180,
                      child: Image.network(
                        travel.photoUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      travel.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text(travel.location),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: const Text("O'chirishga aminmisiz?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Yo'q"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        TravelService()
                                            .deleteLocation(travel.id);
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "Ha",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _showEditLocationDialog(context, travel);
                          },
                          icon: const Icon(Icons.edit),
                        )
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // void _showAddLocationDialog(BuildContext context) {
  //   final _titleController = TextEditingController();
  //   XFile? _pickedImage;
  //   bool _isLoading = false;
  //
  //   Future<void> pickImage(ImageSource source) async {
  //     final picker = ImagePicker();
  //     final pickedImage =
  //         await picker.pickImage(source: source, imageQuality: 60);
  //     if (pickedImage != null) {
  //       _pickedImage = pickedImage;
  //     }
  //   }
  //
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           return AlertDialog(
  //             title: const Text('Add Location'),
  //             content: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 TextField(
  //                   controller: _titleController,
  //                   decoration: const InputDecoration(
  //                     labelText: 'Title',
  //                   ),
  //                 ),
  //                 Row(
  //                   children: [
  //                     TextButton(
  //                       onPressed: () => pickImage(ImageSource.camera),
  //                       child: const Row(
  //                         mainAxisSize: MainAxisSize.min,
  //                         children: [
  //                           Icon(Icons.camera),
  //                           Text('Camera'),
  //                         ],
  //                       ),
  //                     ),
  //                     const SizedBox(width: 10),
  //                     TextButton(
  //                       onPressed: () => pickImage(ImageSource.gallery),
  //                       child: const Row(
  //                         mainAxisSize: MainAxisSize.min,
  //                         children: [Icon(Icons.image), Text('Gallery')],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 if (_isLoading) const CircularProgressIndicator(),
  //               ],
  //             ),
  //             actionsAlignment: MainAxisAlignment.spaceBetween,
  //             actions: [
  //               TextButton(
  //                 onPressed: () => Navigator.of(context).pop(),
  //                 child: const Text('Cancel'),
  //               ),
  //               FilledButton(
  //                 onPressed: () async {
  //                   if (_titleController.text.isNotEmpty &&
  //                       _pickedImage != null) {
  //                     // setState(() {
  //                     //   _isLoading = true;
  //                     // });
  //
  //                     await TravelService().addTravel(
  //                       _titleController.text,
  //                       _pickedImage!.path,
  //                     );
  //                     Navigator.of(context).pop();
  //                   }
  //                 },
  //                 child: const Text('Add'),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  void _showAddLocationDialog(BuildContext context) {
    final titleController = TextEditingController();
    XFile? pickedImage0;
    bool isLoading = false;

    Future<void> pickImage(ImageSource source, Function setState) async {
      final picker = ImagePicker();
      final pickedImage =
          await picker.pickImage(source: source, imageQuality: 60);
      if (pickedImage != null) {
        setState(() {
          pickedImage0 = pickedImage;
        });
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Manzil',
                    ),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () =>
                            pickImage(ImageSource.camera, setState),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.camera),
                            Text('Camera'),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: () =>
                            pickImage(ImageSource.gallery, setState),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [Icon(Icons.image), Text('Gallery')],
                        ),
                      ),
                    ],
                  ),
                  if (pickedImage0 != null) ...[
                    const SizedBox(height: 10),
                    Image.file(File(pickedImage0!.path)),
                  ],
                  if (isLoading) const CircularProgressIndicator(),
                ],
              ),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () async {
                    if (titleController.text.isNotEmpty &&
                        pickedImage0 != null) {
                      setState(() {
                        isLoading = true;
                      });

                      try {
                        await TravelService().addTravel(
                          titleController.text,
                          pickedImage0!.path,
                        );
                      } catch (error) {
                        print("Error adding travel: $error");
                      }

                      setState(() {
                        isLoading = false;
                      });

                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("Qo'shish"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditLocationDialog(BuildContext context, Travel product) {
    final titleController = TextEditingController(text: product.title);
    XFile? pickedImage0;
    bool isLoading = false;

    Future<void> pickImage(ImageSource source) async {
      final picker = ImagePicker();
      final pickedImage =
          await picker.pickImage(source: source, imageQuality: 60);
      if (pickedImage != null) {
        pickedImage0 = pickedImage;
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Manzil',
                    ),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => pickImage(ImageSource.camera),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.camera),
                            Text('Camera'),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: () => pickImage(ImageSource.gallery),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [Icon(Icons.image), Text('Gallery')],
                        ),
                      ),
                    ],
                  ),
                  if (isLoading) const CircularProgressIndicator(),
                ],
              ),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () async {
                    if (titleController.text.isNotEmpty) {
                      setState(() {
                        isLoading = true;
                      });

                      await TravelService().updateLocation(
                        product.id,
                        titleController.text,
                        pickedImage0?.path ?? product.photoUrl,
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("O'zgartirish"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
