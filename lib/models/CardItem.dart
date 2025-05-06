class CardItem {
  final String content;
  final bool isImage;

  CardItem({required this.content, required this.isImage});

  String get key => isImage
      ? content.split('/').last.split('.').first
      : content;
}
