
class LoadingController
{
  bool Function(String text) update;
  bool Function() shutDown;

  LoadingController({required this.shutDown, required this.update});
}