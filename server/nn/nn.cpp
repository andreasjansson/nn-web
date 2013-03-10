#include <node.h>
#include <thread>
#include <dlfcn.h>
#include <stdio.h>
#include <iostream>
#include "nnlib.h"

// node-gyp build

using namespace v8;

bool started = false;

void my_thread()
{
  loop();
}

Neuron *neuron_from_info(const AccessorInfo &info) {
  Local<Object> self = info.Holder();
  Local<External> wrap = Local<External>::Cast(self->GetInternalField(0));
  void* ptr = wrap->Value();
  Neuron *neuron = static_cast<Neuron *>(ptr);
  return neuron;
}

Handle<Value> getID(Local<String> property, const AccessorInfo &info) {
  Neuron *neuron = neuron_from_info(info);
  return Integer::New((size_t)neuron);
}

Handle<Value> getActivation(Local<String> property, const AccessorInfo &info) {
  Neuron *neuron = neuron_from_info(info);
  return Number::New(neuron->activation);
}

Handle<Value> getBias(Local<String> property, const AccessorInfo &info) {
  Neuron *neuron = neuron_from_info(info);
  return Number::New(neuron->bias);
}

Handle<Value> getState(const Arguments& args) {

  HandleScope scope;

  if(!started) {
    setup();
    std::thread *t = new std::thread(my_thread);
    started = true;
  }

  Handle<ObjectTemplate> neuron_templ = ObjectTemplate::New();
  neuron_templ->SetInternalFieldCount(1);
  neuron_templ->SetAccessor(String::New("id"), getID);
  neuron_templ->SetAccessor(String::New("activation"), getActivation);
  neuron_templ->SetAccessor(String::New("bias"), getBias);

  Handle<Array> synapses = Array::New();

  Network *network = get_network();
  Handle<Array> jsLayers = Array::New(network->layers.size());

  for(unsigned int i = 0; i < network->layers.size(); i ++) {
    Layer *layer = network->layers[i];
    Handle<Array> jsLayer = Array::New(layer->size());
    for(unsigned int j = 0; j < layer->size(); j ++) {
      Neuron *neuron = (*layer)[j];
      Handle<Object> jsNeuron = neuron_templ->NewInstance();
      jsNeuron->SetInternalField(0, External::New(neuron));
      jsLayer->Set(j, jsNeuron);
    }
    jsLayers->Set(i, jsLayer);
  }

  return scope.Close(jsLayers);
}

void RegisterModule(Handle<Object> target) {
  target->Set(String::NewSymbol("getState"),
              FunctionTemplate::New(getState)->GetFunction());
}

NODE_MODULE(nn, RegisterModule);
