(($) ->
  pluginName = 'editMe'
  methods =
    init:(options) ->
      # Defaults
      opts = $.extend
        activateEvent: 'click dblclick'
        deactivateEvent: 'blur'
        class: ''
        type: 'text' # textarea, select
        options: false
        ,options

      this.each ->
        # create hidden input
        el = $(this)
        createInput el,opts
    activate: ->
      this.next().show().focus()
      this.hide()
      console.log 'activate', this, arguments
    deactivate: (event)->
      console.log 'deactivate', this, arguments
      input = $(event.target)
      value = input.val()
      this.text value
      this.next().next().val(value)
      this.show()
      input.hide()
    toggle: (event) ->

    change: (event)->
      input = $(event.target)
      value = input.val()
      this.text value
      input.next().val value
      console.log 'changed', $(this),value, input


  #Private
  createInput = (el, opts)->
    inputName = if id = el.attr('id') then id else null
    if name = el.data('name') then inputName = name
    return unless inputName # ignore fields with undefined id or data-name
    
    el.on  opts.activateEvent, (event) -> el.editMe('activate', event)

    hidden = $("<input/>",
      name: 'hidden_' + inputName
      type: "hidden"
      value: $.trim el.text()
    )
    el.after hidden

    input = $('<input/>',
      name: 'input_' + inputName
      type: "text"
      class: "editMe editField" 
      value: $.trim el.text()
    ).hide()
    el.after input
    input.on opts.deactivateEvent, (event)-> el.editMe('deactivate', event)
    input.on 'change keyup input', (event)-> el.editMe('change', event)


    #input.css el.getStyleObject()
    input.height el.height()
    input.width el.width()
    
  $.fn.editMe = (method) ->
    if methods[method]
      methods[method].apply  this, Array.prototype.slice.call( arguments, 1)
    else if typeof method is 'object' || ! method
      methods.init.apply this, arguments 
    else
      console.log "Method #{method} does not exist on jQuery.#{pluginName}"
  #end
)(jQuery)
