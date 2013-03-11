class @NetworkView extends Backbone.View

    el: $('body')

    initialize: (options) ->
        @minSpacing = .5 # fraction of radius
        @width = options.width
        @height = options.height

    setNeuronsAndSynapses: (neurons, synapses, layerSizes) =>
        layersCount = layerSizes.length
        maxLayerSize = Math.max(layerSizes...)
        radius = @getNeuronRadius(layersCount, maxLayerSize)
        spacing = @getNeuronSpacing(radius, layersCount, maxLayerSize)
        layerYOffsets = @getLayerYOffsets(layerSizes, radius, spacing.y)

        for id, neuron of neurons
            view = neuron.view
            position = @getNeuronPosition(radius, neuron.get('layer'), neuron.get('index'), spacing, layerYOffsets[neuron.get('layer')])
            view.setRadius(radius)
            view.moveTo(position.x, position.y)

        for id, synapse of synapses
            view = synapse.view
            from = synapse.get('from')
            to = synapse.get('to')
            fromPosition = @getNeuronPosition(radius, from.get('layer'), from.get('index'), spacing, layerYOffsets[from.get('layer')])
            toPosition = @getNeuronPosition(radius, to.get('layer'), to.get('index'), spacing, layerYOffsets[to.get('layer')])
            view.setPositions(fromPosition.x, fromPosition.y, toPosition.x, toPosition.y)

    getNeuronRadius: (layersCount, maxLayerSize) =>
        getR = (length, n) =>
            length / (n * @minSpacing - @minSpacing + 2 * n)
        return Math.min(getR(@width, layersCount), getR(@height, maxLayerSize))

    getNeuronSpacing: (radius, layersCount, maxLayerSize) =>
        getSpacing = (length, n) =>
            (length - 2 * n * radius) / (n - 1)
        return x: getSpacing(@width, layersCount), y: getSpacing(@height, maxLayerSize)

    getLayerYOffsets: (layerSizes, radius, spacing) =>
        offsets = []
        for size in layerSizes
            layerHeight = 2 * radius * size + spacing * (size - 1)
            offsets.push((@height - layerHeight) / 2)
        return offsets

    getNeuronPosition: (radius, layer, index, spacing, layerYOffset) =>
        getPos = (i, spacing, offset) ->
            return i * spacing + radius + 2 * i * radius + offset

        x = getPos(layer, spacing.x, 0)
        y = getPos(index, spacing.y, layerYOffset)

        return x: x, y: y
