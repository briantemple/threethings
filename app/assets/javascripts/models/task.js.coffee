class Threethings.Models.Task extends Backbone.Model
  paramRoot: 'task'
  
  restart: ->
    @set(status: 0)
    @set(completed_at: "")
    @save()
    
  complete: ->
    @set(status: 1)
    @set(completed_at: new Date())
    @save()