class @NeuronView extends Backbone.View

    el: $('body')

    initialize: (options) ->
        @model.on('change', @render)
        @model.on('destroy', @remove)
        @circle = @getCircle()
        @render()

    getCircle: =>
        x = @model.get('layer') * Options.SPACING_X + Options.TOP_LEFT_X
        y = @model.get('index') * Options.SPACING_Y + Options.TOP_LEFT_Y
        circle = window.paper.circle(x, y, Options.RADIUS)
        circle.toFront()
        return circle

    render: =>
        grey = @model.get('activation') * 255
        @circle.attr('fill', Raphael.rgb(grey, grey, grey))

    remove: =>
        @circle.remove()