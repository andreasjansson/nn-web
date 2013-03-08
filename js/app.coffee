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

    update: (layers, synapseDatas) =>
        newNeurons = {}
        for i, neuronDatas of layers
            for j, neuronData of neuronDatas
                id = neuronData.id
                if id of @neurons
                    newNeurons[id] = @neurons[id]
                    delete @neurons[id]
                else
                    newNeurons[id] = new Neuron(layer: i, index: j)
                    new NeuronView(model: newNeurons[id])
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
                new SynapseView(model: newSynapses[id])
            newSynapses[id].set(weight: synapseData.weight)

        for id, synapse of @synapses
            synapse.destroy()

        @synapses = newSynapses


$ -> window.app = new App
