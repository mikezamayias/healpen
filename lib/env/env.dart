import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'OPEN_AI_API_KEY', obfuscate: true)
  static final String openAiApiKey = _Env.openAiApiKey;
  @EnviedField(varName: 'GOOGLE_APIS_KEY', obfuscate: true)
  static final String googleApisKey = _Env.googleApisKey;
  @EnviedField(varName: 'HEALPEN_GITHUB_TOKEN', obfuscate: true)
  static final String healpenGithubToken = _Env.healpenGithubToken;
}
