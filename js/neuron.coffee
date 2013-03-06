class @Neuron extends Backbone.Model

    defaults:
        activation: .5
        bias: 0
        synapses: []
        layer: undefined
        index: undefined
#        outgoingSynapses: [] # how to add to a list like this in backbone? set() ...?
#        incomingSynapses: []
