class App

    constructor: ->

        $body = $('body')
        window.paper = Raphael(0, 0, $body.width(), $body.height())
        new RaphaelZPD(window.paper, zoom: true, pan: true, drag: false)

        @neurons = {}
        @synapses = {}

        @socket = io.connect(sprintf('http://%s:%d', Options.SOCKET_HOST, Options.SOCKET_PORT))
        @socket.emit('test')
        @socket.on('update', @update)

        @networkView = new NetworkView(width: $body.width(), height: $body.height())

    update: (layers, synapseDatas) =>
        newNeurons = {}
        layerSizes = []
        for i, neuronDatas of layers
            layerSizes.push(neuronDatas.length)
            for j, neuronData of neuronDatas
                id = neuronData.id
                if id of @neurons
                    newNeurons[id] = @neurons[id]
                    delete @neurons[id]
                else
                    newNeurons[id] = new Neuron(layer: parseInt(i, 10), index: parseInt(j, 10))
                    newNeurons[id].view = new NeuronView(model: newNeurons[id])
                newNeurons[id].set(activation: neuronData.activation, bias: neuronData.bias)

        for id, neuron of @neurons
            neuron.destroy()

        @neurons = newNeurons

        newSynapses = {}
        for i, synapseData of synapseDatas
            id = synapseData.from + '-' + synapseData.to
            if id of @synapses
                newSynapses[id] = @synapses[id]
                delete @synapses[id]
            else
                newSynapses[id] = new Synapse(from: @neurons[synapseData.from], to: @neurons[synapseData.to])
                newSynapses[id].view = new SynapseView(model: newSynapses[id])
            newSynapses[id].set(weight: synapseData.weight)

        for id, synapse of @synapses
            synapse.destroy()

        @synapses = newSynapses

        @networkView.setNeuronsAndSynapses(@neurons, @synapses, layerSizes)


$ -> window.app = new App
