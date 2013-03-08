#include <node.h>
#include <thread>

// node-gyp build CXXFLAGS='-std=c++0x'

using namespace v8;

bool started = false;

double activation = 0;

void my_thread() {
  while(true) {
    activation += .1;
    if(activation > 1)
      activation -= 1;
    std::chrono::milliseconds dura(100);
    std::this_thread::sleep_for(dura);
  }
}

Handle<Value> getID(Local<String> property, const AccessorInfo &info) {
  return Integer::New(0);
}

Handle<Value> getActivation(Local<String> property, const AccessorInfo &info) {
  return Number::New(activation);
}

Handle<Value> getBias(Local<String> property, const AccessorInfo &info) {
  return Integer::New(0);
}

Handle<Value> getState(const Arguments& args) {

  if(!started) {
    std::thread *t = new std::thread(my_thread);
    started = true;
  }

  HandleScope scope;

  Handle<ObjectTemplate> neuron_templ = ObjectTemplate::New();
  neuron_templ->SetAccessor(String::New("id"), getID);
  neuron_templ->SetAccessor(String::New("activation"), getActivation);
  neuron_templ->SetAccessor(String::New("bias"), getBias);

  Handle<Array> neurons = Array::New(1);

  neurons->Set(0, neuron_templ->NewInstance());

  return scope.Close(
    neurons
  );

}

void RegisterModule(Handle<Object> target) {
  target->Set(String::NewSymbol("getState"),
              FunctionTemplate::New(getState)->GetFunction());
}

NODE_MODULE(nn, RegisterModule);
