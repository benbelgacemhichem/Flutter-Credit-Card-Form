enum DibsyEnvironnement { test, live }

void initializeDibsy({required env, required pkTest, required pkLive}) {
  DibsyConfig.environnement = env;
  DibsyConfig.publicTestKey = pkTest;
  DibsyConfig.publicLiveKey = pkLive;
}

class DibsyConfig {
  static DibsyEnvironnement environnement = DibsyEnvironnement.test;
  static String publicTestKey = '';
  static String publicLiveKey = '';

  static String get env {
    switch (environnement) {
      case DibsyEnvironnement.test:
        return 'test';
      case DibsyEnvironnement.live:
        return 'live';
    }
  }

  static String get pk {
    switch (environnement) {
      case DibsyEnvironnement.test:
        return publicTestKey;
      case DibsyEnvironnement.live:
        return publicLiveKey;
    }
  }
}
