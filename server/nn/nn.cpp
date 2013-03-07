#include <node.h>

// node-gyp build

using namespace v8;

Handle<Value> getID(Local<String> property, const AccessorInfo &info) {
  return Integer::New(0);
}

Handle<Value> getActivation(Local<String> property, const AccessorInfo &info) {
  return Integer::New(0);
}

Handle<Value> getBias(Local<String> property, const AccessorInfo &info) {
  return Integer::New(0);
}

Handle<Value> getState(const Arguments& args) {
  HandleScope scope;

  Handle<ObjectTemplate> neuron_templ = ObjectTemplate::New();
  neuron_templ->SetAccessor(String::New("id"), getID);
  neuron_templ->SetAccessor(String::New("activation"), getActivation);
  neuron_templ->SetAccessor(String::New("bias"), getBias);

  Handle<Array> neurons = Array::New(3);

  neurons->Set(0, neuron_templ->NewInstance());
  neurons->Set(1, neuron_templ->NewInstance());
  neurons->Set(2, neuron_templ->NewInstance());

  return scope.Close(
    neurons
  );

}

void RegisterModule(Handle<Object> target) {
  target->Set(String::NewSymbol("getState"),
              FunctionTemplate::New(getState)->GetFunction());
}

NODE_MODULE(nn, RegisterModule);
