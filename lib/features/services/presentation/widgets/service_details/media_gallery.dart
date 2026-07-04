import 'package:eventy_customer/core/utils/service_type_helper.dart';
import 'package:eventy_customer/features/services/data/models/service_details_model.dart';
import 'package:eventy_customer/features/services/presentation/pages/video_player_page.dart';
import 'package:eventy_customer/features/services/presentation/widgets/services/service_placeholder.dart';
import 'package:flutter/material.dart';

class MediaGallery extends StatefulWidget {
  final List<ServiceFile> files;
  final String serviceTypeName;
  final String heroTag;

  const MediaGallery({
    super.key,
    required this.files,
    required this.serviceTypeName,
    required this.heroTag,
  });

  @override
  State<MediaGallery> createState() => _MediaGalleryState();
}

class _MediaGalleryState extends State<MediaGallery> {
  final PageController _controller = PageController();
  int _current = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.files.isEmpty) {
      return Hero(
        tag: widget.heroTag,
        child: ServicePlaceholder(
          type: ServiceTypeHelper.displayName(widget.serviceTypeName),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Hero(
          tag: widget.heroTag,
          child: PageView.builder(
            controller: _controller, 
            itemCount: widget.files.length,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (_, index) {
              final file = widget.files[index];

              if (file.isVideo) {
                return _VideoThumbnail(file: file);
              }

              return Image.network(
                file.fileUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => ServicePlaceholder(
                  type: ServiceTypeHelper.displayName(widget.serviceTypeName),
                ),
              );
            },
          ), 
        ),

        if (widget.files.length > 1)
          Positioned(
            bottom: 16, 
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.files.length, (i) {
                final active = i == _current;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: active ? 20 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(active ? 1 : .5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}

class _VideoThumbnail extends StatelessWidget {
  final ServiceFile file;

  const _VideoThumbnail({required this.file});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VideoPlayerPage(url: file.fileUrl),
          ),
        );
      },
      child: Container(
        color: Colors.black87,
        child: Center(
          child: Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.5),
            ),
            child: const Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 34,
            ),
          ),
        ),
      ),
    );
  }
}