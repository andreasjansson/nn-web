require('coffee-script')

io = require('socket.io').listen(8080, log: false)
net = require('net')

io.sockets.on('connection', (socket) ->
    id = socket.id
    layers = []
    synapses = []
    for i in [0...3]
        layer = []
        for j in [0..10]
            neuron = {id: j + i * 10, activation: Math.random(), bias: Math.random()}
            layer.push(neuron)
        layers.push(layer)
    synapses = [{from: 0, to: 10}, {from: 1, to: 11}]
    socket.emit('update', layers, synapses)
)
