import 'package:flutter/material.dart';


class MediaPickerBottomSheet extends StatelessWidget {
  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;
  

  const MediaPickerBottomSheet({
    super.key,
    required this.onCameraTap,
    required this.onGalleryTap,
    
  });

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onCameraTap,
    required VoidCallback onGalleryTap,
   
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => MediaPickerBottomSheet(
        onCameraTap: () {
          Navigator.pop(context);
          onCameraTap();
        },
        onGalleryTap: () {
          Navigator.pop(context);
          onGalleryTap();
        },
        
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera, color: Theme.of(context).colorScheme.onSurface),
              title: Text('Open Camera', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
              onTap: onCameraTap,
            ),
            ListTile(
              leading: Icon(Icons.browse_gallery, color: Theme.of(context).colorScheme.onSurface),
              title: Text('Open Gallery', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
              onTap: onGalleryTap,
            ),
            
          ],
        ),
      ),
    );
  }
}
