require('coffee-script')
nn = require('./nn/build/Release/nn.node')

io = require('socket.io').listen(8080, log: false)
net = require('net')

io.sockets.on('connection', (socket) ->
    id = socket.id
    ###
    layers = []
    synapses = []
    for i in [0...3]
        layer = []
        for j in [0...10]
            neuron = {id: j + i * 10, activation: Math.random(), bias: Math.random()}
            layer.push(neuron)
        layers.push(layer)
    synapses = [{from: 0, to: 10}, {from: 9, to: 11}]
    ###
    [layers, synapses] = nn.getState()
    setInterval ->
        [layers, synapses] = nn.getState()
        socket.emit('update', layers, synapses)
    , 500
    socket.emit('update', layers, synapses)
)
