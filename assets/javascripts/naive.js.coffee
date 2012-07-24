//= require_tree ./vendor
//= require_self
//= require_tree ./naive
//= require nighthawks

window.NAIVE = {}
class NAIVE.Game
  frame: 0
  constructor: (options) ->
    @$e = $(".canvas")
    @actor = new NAIVE.Actor()
    @actor.position = new NAIVE.P(-150, 550)
    @walkAreas = options.walkAreas
    document.title = @title
    @$e.find(".click-layer").bind "click", @onClick
    @initializeDebug()
    @startLoop()

  runLoop: () =>
    @actor.update()

  startLoop: ->
    @loopInterval = window.setInterval @runLoop, 125

  stopLoop: ->
    window.clearInterval @loopInterval

  onClick: (e) =>
    e.preventDefault()
    p = new NAIVE.P(e.offsetX, e.offsetY)
    console.log p.toString(), e

    if area = @findAreaForPoint(p)
      @actor.goTo(p)
      #area.onClick(p, @game, @actor)
    else
      closestPoint = @findClosestPointInWalkingAreaForPoint(p)
      @actor.goTo(closestPoint)

  findAreaForPoint: (point) ->
    foundArea = null
    for areaCollection in [@walkAreas]
      for area in areaCollection
        if area.polygon.isPointWithin(point)
          foundArea = area
    foundArea

  findClosestPointInWalkingAreaForPoint: (point) ->
    for y in [(point.y)..@height]
      currentPoint = new NAIVE.P(point.x, y)
      for area in @walkAreas
        if area.polygon.isPointWithin(currentPoint)
          return currentPoint
    null

  initializeDebug: ->
    @debugCanvas = @setupDebugCanvas()

  setupDebugCanvas: ->
    canvas = $(".canvas")
    c = $("<canvas class='debugCanvas'/>").appendTo(canvas)
    c.attr("width", canvas.width())
    c.attr("height", canvas.height())
    window.ctx = c[0].getContext("2d")

  debugAreas: ->
    for area in @walkAreas
      console.log(area)
      area.polygon.toCanvas(@debugCanvas)
