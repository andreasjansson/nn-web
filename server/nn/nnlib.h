#ifndef NNLIB_H
#define NNLIB_H

#include "../../../../network.h"

extern "C" {
  void loop();
  void setup();
  Network *get_network();
}

#endif
