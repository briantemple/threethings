class Threethings.Routers.Tasks extends Backbone.Router
  routes:
    '': 'index'
    'tasks/:id': 'show'
    'tasks': 'index'
    'about': 'about'
    '*catchall': 'unknown'
    
  initialize: ->
    @collection = new Threethings.Collections.Tasks()
    @collection.fetch()
    
  index: ->
    view = new Threethings.Views.TasksIndex(collection: @collection)
    $('#container').html(view.render().el)
    
  show: (id) ->
    alert "Task #{id}"
    
  unknown: ->
    this.navigate('/', true)
    
  about: ->
    $('#container').html(JST['about/index'])