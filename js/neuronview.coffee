class @NeuronView extends Backbone.View

    el: $('body')

    initialize: (options) ->
        @model.on('change', @render)
        @model.on('destroy', @remove)
        @circle = window.paper.circle(0, 0, 0)
        @circle.toFront()
        @label = new LabelView(getValue: =>
            sprintf('%.3f, %.3f', @model.get('activation'), @model.get('bias')))
        @render

    moveTo: (x, y) =>
        @circle.attr('cx', x)
        @circle.attr('cy', y)
        @label.setTargetPosition(x, y)

    setRadius: (radius) =>
        @circle.attr('r', radius)

    render: =>
        grey = @model.get('activation') * 64 + 128
        @circle.attr('fill', Raphael.rgb(grey, grey, grey))
        @label.render()
        return @

    remove: =>
        @circle.remove()
        @label.remove()
