window.Threethings =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: -> 
    new Threethings.Routers.Tasks()
    Backbone.history.start(pushState: true)

$(document).ready ->
  Threethings.initialize()

# Helper method for array that allows a .last() instead of using array[..].pop()
Array::last = -> @[@length - 1]
