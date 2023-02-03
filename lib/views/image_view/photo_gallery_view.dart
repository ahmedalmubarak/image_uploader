import 'package:bloc_fairebase_auth/bloc/app_bloc.dart';
import 'package:bloc_fairebase_auth/views/components/main_popup_menu_button.dart';
import 'package:bloc_fairebase_auth/views/image_view/storage_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';

class PhotoGalleryView extends HookWidget {
  const PhotoGalleryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final picker = useMemoized(() => ImagePicker(), [key]);
    final images = context.watch<AppBloc>().state.images ?? [];
    final pushUploadEvent = context.read<AppBloc>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Gallery'),
        actions: [
          IconButton(
            onPressed: () async {
              final image = await picker.pickImage(
                source: ImageSource.gallery,
              );
              if (image == null) {
                return;
              }
              pushUploadEvent.add(
                AppEventUploadImage(filePathToUpload: image.path),
              );
            },
            icon: const Icon(Icons.upload),
          ),
          const MainPopupMenuButton(),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(8.0),
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 20.0,
        children: images.map((img) => StorageImageView(image: img)).toList(),
      ),
    );
  }
}
