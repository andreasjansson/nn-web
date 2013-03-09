#ifndef NNLIB_H
#define NNLIB_H

extern "C" {
  void loop();
  vector<Layer *> &get_layers();
}

#endif
