class @SynapseView extends Backbone.View

    el: $('body')

    initialize: (options) ->
        @model.on('change', @render)
        @model.on('destroy', @remove)
        @line = @getLine()
        @render()

    render: =>
        grey = @model.get('weight') * 255
        @line.attr('stroke', Raphael.rgb(grey, grey, grey))

    getLine: =>
        fromX = @model.get('from').get('layer') * Options.SPACING_X + Options.TOP_LEFT_X
        fromY = @model.get('from').get('index') * Options.SPACING_Y + Options.TOP_LEFT_Y
        toX = @model.get('to').get('layer') * Options.SPACING_X + Options.TOP_LEFT_X
        toY = @model.get('to').get('index') * Options.SPACING_Y + Options.TOP_LEFT_Y
        line = window.paper.path(sprintf('M%d %dL%d %d', fromX, fromY, toX, toY))
        line.toBack()
        return line

    remove: =>
        @line.remove()