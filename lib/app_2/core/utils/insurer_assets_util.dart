import 'package:flutter/foundation.dart';

final String pathPrefix = (kIsWeb && kDebugMode) ? '' : 'assets';

String getInsurerImage(String insurerName) {
  if (insurerName.contains('Sanlam')) {
    return '${pathPrefix}/images/insurer_assets/sanlam_insurance.png';
  }

  if (insurerName.contains('Geminia')) {
    return '${pathPrefix}/images/insurer_assets/geminia_insurance.png';
  }

  if (insurerName.contains('APA')) {
    return '${pathPrefix}/images/insurer_assets/apa_insurance.png';
  }

  if (insurerName.contains('APA Medical')) {
    return '${pathPrefix}/images/insurer_assets/apa_medical_insurance.png';
  }

  if (insurerName.contains('Jubilee Allianz')) {
    return '${pathPrefix}/images/insurer_assets/jubilee_allianz_insurance.png';
  }

  if (insurerName.contains('Fidelity')) {
    return '${pathPrefix}/images/insurer_assets/fidelity_insurance.png';
  }

  if (insurerName.contains('Prudential Life')) {
    return '${pathPrefix}/images/insurer_assets/prudential_life_insurance.png';
  }

  if (insurerName.contains('Monarch')) {
    return '${pathPrefix}/images/insurer_assets/monarch.png';
  }

  if (insurerName.contains('Mutual')) {
    return '${pathPrefix}/images/insurer_assets/old_mutual.png';
  }

  if (insurerName.contains('Orient')) {
    return '${pathPrefix}/images/insurer_assets/kenya_orient.png';
  }

  if (insurerName.contains('Britam')) {
    return '${pathPrefix}/images/insurer_assets/britam.png';
  }

  if (insurerName.contains('Madison')) {
    return '${pathPrefix}/images/insurer_assets/madison.png';
  }

  if (insurerName.contains('First')) {
    return '${pathPrefix}/images/insurer_assets/first_assurance.png';
  }

  if (insurerName.contains('Heritage')) {
    return '${pathPrefix}/images/insurer_assets/heritage.png';
  }

  if (insurerName.contains('CIC')) {
    return '${pathPrefix}/images/insurer_assets/cic.png';
  }

  if (insurerName.contains('Cannon')) {
    return '${pathPrefix}/images/insurer_assets/cannon.png';
  }

  if (insurerName.contains('Pioneer')) {
    return '${pathPrefix}/images/insurer_assets/pioneer.png';
  }

  if (insurerName.contains('Star')) {
    return '${pathPrefix}/images/insurer_assets/star.png';
  }

  if (insurerName.contains('Occidental')) {
    return '${pathPrefix}/images/insurer_assets/occidental.png';
  }

  if (insurerName.contains('Direct')) {
    return '${pathPrefix}/images/insurer_assets/direct.png';
  }

  if (insurerName.contains('GA')) {
    return '${pathPrefix}/images/insurer_assets/ga_insurance.png';
  }

  if (insurerName.contains('ICEA')) {
    return '${pathPrefix}/images/insurer_assets/icea_insurance.png';
  }

  if (insurerName.contains('Pacis')) {
    return '${pathPrefix}/images/insurer_assets/pacis_insurance.png';
  }

  if (insurerName.contains('NCBA')) {
    return '${pathPrefix}/images/insurer_assets/ncba_insurance.png';
  }
  return '${pathPrefix}/images/insurer_assets/default_insurance.png';
}
