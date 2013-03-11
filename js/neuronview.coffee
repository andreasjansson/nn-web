class @NeuronView extends Backbone.View

    el: $('body')

    initialize: (options) ->
        @model.on('change', @render)
        @model.on('destroy', @remove)
        @circle = window.paper.circle(0, 0, 0)
        @circle.toFront()
        @render

    moveTo: (x, y) =>
        @circle.attr('cx', x)
        @circle.attr('cy', y)

    setRadius: (radius) =>
        @circle.attr('r', radius)

    render: =>
        grey = @model.get('activation') * 64 + 128
        @circle.attr('fill', Raphael.rgb(grey, grey, grey))
        return @

    remove: =>
        @circle.remove()