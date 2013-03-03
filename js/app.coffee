class App

    constructor: ->

        $body = $('body')
        window.paper = Raphael(0, 0, $body.width(), $body.height())

        @neurons = []
        neuronsByLayer = {}
        for layerIndex in [0...3]
            for neuronIndex in [0...10]
                neuron = new Neuron(layerIndex: layerIndex, neuronIndex: neuronIndex)
                @neurons.push(neuron)
                new NeuronView(model: neuron)

                if neuronIndex == 0
                    neuronsByLayer[layerIndex] = [neuron]
                else:
                    neuronsByLayer[layerIndex].push(neuron)
                if layerIndex > 0
                    for previousNeuron in neuronsByLayer[layerIndex - 1]
                        synapse = new Synapse(from: previousNeuron, to: neuron)
                        synapseView = new SynapseView(model: synapse)


$ -> new App
