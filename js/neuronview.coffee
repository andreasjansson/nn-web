class @NeuronView extends Backbone.View

    el: $('body')

    initialize: (options) ->
        @model.on('change', @render)
        @circle = @getCircle()
        @render()

    getCircle: =>
        x = @model.get('layerIndex') * Options.SPACING_X + Options.TOP_LEFT_X
        y = @model.get('neuronIndex') * Options.SPACING_Y + Options.TOP_LEFT_Y
        circle = window.paper.circle(x, y, Options.RADIUS)
        return circle

    render: =>
        grey = @model.get('activation') * 255
        @circle.attr('fill', Raphael.rgb(grey, grey, grey))
