class @SynapseView extends Backbone.View

    el: $('body')

    initialize: (options) ->
        @model.on('change', @render)
        @model.on('destroy', @remove)
        @line = window.paper.path()
        @line.toBack()
        @render()

    render: =>
        grey = @model.get('weight') * 255
        @line.attr('stroke', Raphael.rgb(grey, grey, grey))

    setPositions: (fromX, fromY, toX, toY) =>
        @line.attr('path', sprintf('M%d %dL%d %d', fromX, fromY, toX, toY))

    remove: =>
        @line.remove()