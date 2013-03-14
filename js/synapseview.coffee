class @SynapseView extends Backbone.View

    el: $('body')

    initialize: (options) ->
        @model.on('change', @render)
        @model.on('destroy', @remove)
        @line = window.paper.path()
        @line.toBack()
        @label = new LabelView(getValue: =>
            sprintf('%.3f', @model.get('weight')))
        @render()

    render: =>
        grey = @model.get('weight') * 40 + 128
        @line.attr('stroke', Raphael.rgb(grey, grey, grey))
        @label.render()
        return @

    setPositions: (fromX, fromY, toX, toY) =>
        @line.attr('path', sprintf('M%d %dL%d %d', fromX, fromY, toX, toY))
        @label.setTargetPosition(fromX * 4/5 + toX * 1/5, fromY * 4/5 + toY * 1/5)

    remove: =>
        @line.remove()
        @label.remove()
