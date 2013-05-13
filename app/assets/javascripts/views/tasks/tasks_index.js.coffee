class Threethings.Views.TasksIndex extends Backbone.View

  template: JST['tasks/index']
  editTaskPartial: JST['tasks/edit']
  newTaskPartial: JST['tasks/new']
  
  events:
    'click .todo input[type=checkbox]': 'finishTask',
    'click .done input[type=checkbox]': 'restartTask',
    'click .editable': 'editTask',
    'blur .todo textarea.edit_task': 'finishedEditingTask',
    'keypress': 'handleKeyboard'
    
  
  initialize: ->
    @collection.on('sync', @render, this)

  render: ->    
    todo = @collection.filter (model) -> model.get('status') == 0
    done = @collection.filter (model) -> model.get('status') == 1
    console.log ("todo: #{todo.length}, done:#{done.length}")
    $(@el).html(@template(tasks: @collection, todo: todo, done: done))
    this
 
  isNewTask: (id) ->
    id.split('_')[0] == 'new'
       
  finishTask: (event) ->
    id = event.target.id.split('_').last()
    @collection.get(id).complete()
  
  restartTask: (event) ->
    id = event.target.id.split('_').last()
    @collection.get(id).restart()

  editTask: (event) ->
    id = event.target.id
    value = ""
    unless @.isNewTask(id)
      value = event.target.textContent
    
    $(event.target.parentNode).html(@editTaskPartial(id: event.target.id, value:value))
    $("#"+id).focus()
    $("#"+id).select()
    
  finishedEditingTask: (event) ->
    event.preventDefault()
    id = event.target.id.split('_').last()
    if event.target.value
      if @.isNewTask(event.target.id)
        @collection.create { name: event.target.value },
          wait: true
      else
        task = @collection.get(id)
        if task.get('name') == event.target.value
          $(event.target.parentNode).html(@newTaskPartial(id: event.target.id, task: task))
        else
          task.save {name: event.target.value}, wait: true
    else
      targetId = event.target.id
      unless @.isNewTask(targetId)
        task = @collection.get(id)
        task.destroy wait: true
        targetId = "new_task_" + (@collection.length + 1)
      $(event.target.parentNode).html(@newTaskPartial(id: targetId))

    
  handleKeyboard: (event) ->
    if $(event.target).is("textarea")
      # If the escape key is pressed, clear and blur (don't save)
      if event.keyCode == 27
        task = null
        unless @.isNewTask(event.target.id)
          task = @collection.get(event.target.id.split('_').last())
        $(event.target.parentNode).html(@newTaskPartial(id: event.target.id, task: task))
      
      # If enter is pressed, blur (save if there are contents)
      if event.keyCode == 13
        $(event.target).blur()

