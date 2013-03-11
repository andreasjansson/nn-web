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

Synapse *synapse_from_info(const AccessorInfo &info) {
  Local<Object> self = info.Holder();
  Local<External> wrap = Local<External>::Cast(self->GetInternalField(0));
  void* ptr = wrap->Value();
  Synapse *synapse = static_cast<Synapse *>(ptr);
  return synapse;
}

Handle<Value> neuron_get_property(Local<String> property, const AccessorInfo &info) {
  Neuron *neuron = neuron_from_info(info);
  if(property->Equals(String::New("id")))
    return Integer::New((size_t)neuron);
  if(property->Equals(String::New("activation")))
    return Number::New(neuron->activation);
  if(property->Equals(String::New("bias")))
    return Number::New(neuron->bias);
  return Undefined();
}

Handle<Value> synapse_get_property(Local<String> property, const AccessorInfo &info) {
  Synapse *synapse = synapse_from_info(info);
  if(property->Equals(String::New("from")))
    return Integer::New((size_t)synapse->from);
  if(property->Equals(String::New("to")))
    return Integer::New((size_t)synapse->to);
  if(property->Equals(String::New("weight")))
    return Number::New(synapse->weight);
  return Undefined();
}

Handle<Value> getState(const Arguments& args) {

  HandleScope scope;

  if(!started) {
    setup();
    std::thread *t = new std::thread(my_thread);
    started = true;
  }

  // todo: make these static, or something
  Handle<ObjectTemplate> neuron_templ = ObjectTemplate::New();
  neuron_templ->SetInternalFieldCount(1);
  neuron_templ->SetAccessor(String::New("id"), neuron_get_property);
  neuron_templ->SetAccessor(String::New("activation"), neuron_get_property);
  neuron_templ->SetAccessor(String::New("bias"), neuron_get_property);

  Handle<ObjectTemplate> synapse_templ = ObjectTemplate::New();
  synapse_templ->SetInternalFieldCount(1);
  synapse_templ->SetAccessor(String::New("from"), synapse_get_property);
  synapse_templ->SetAccessor(String::New("to"), synapse_get_property);
  synapse_templ->SetAccessor(String::New("bias"), synapse_get_property);

  Network *network = get_network();

  Handle<Array> js_layers = Array::New(network->layers.size());
  Handle<Array> js_synapses = Array::New();

  int synapse_index = 0;
  for(unsigned int i = 0; i < network->layers.size(); i ++) {
    Layer *layer = network->layers[i];
    Handle<Array> js_layer = Array::New(layer->size());
    for(unsigned int j = 0; j < layer->size(); j ++) {
      Neuron *neuron = (*layer)[j];
      Handle<Object> js_neuron = neuron_templ->NewInstance();
      js_neuron->SetInternalField(0, External::New(neuron));
      js_layer->Set(j, js_neuron);

      for(Synapse *synapse : neuron->outgoing_synapses) {
        Handle<Object> js_synapse = synapse_templ->NewInstance();
        js_synapse->SetInternalField(0, External::New(synapse));
        js_synapses->Set(synapse_index, js_synapse);
        synapse_index ++;
      }
    }
    js_layers->Set(i, js_layer);
  }

  Handle<Array> ret = Array::New(2);
  ret->Set(0, js_layers);
  ret->Set(1, js_synapses);

  return scope.Close(ret);
}

void RegisterModule(Handle<Object> target) {
  target->Set(String::NewSymbol("getState"),
              FunctionTemplate::New(getState)->GetFunction());
}

NODE_MODULE(nn, RegisterModule);
