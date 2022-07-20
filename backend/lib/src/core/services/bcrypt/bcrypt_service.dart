abstract class BCryptService {
  String generateHash(String text);
  bool checkHash(String text, String hash);
}
