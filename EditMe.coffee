(($) ->
  pluginName = 'editMe'
  opts = {}
  methods =
    init:(options) ->
      # Defaults
      opts = $.extend
        activateEvent: 'click dblclick'
        deactivateEvent: 'blur'
        syncEvent: 'change keyup input'
        class: ''
        type: 'text' # textarea, select
        options: false
        hiddenPrefix: 'hidden_'
        hiddenSuffix: ''
        debug: true
        ,options

      this.each ->
        el = $(this)
        # get name of the input element
        inputName = getInputName el
        if inputName
          el.data 'EditMe',
            name: inputName,
            hidden: null,
            edit: null
          # create hidden input
          createHiddenInput el,opts
          el.on opts.activateEvent, (event) -> el.editMe('activate', event)
        else
          log 'Can\'t determine input name. Element was skipped ', el

    activate: ->
      data = this.data "EditMe"
      createEditInput this unless data.edit
      data.edit.show().focus()
      this.hide()
      
    deactivate: (event)->
      data = this.data('EditMe')
      edit = data.edit
      console.log 'deactivate', edit.val(), arguments
      return this unless edit
      value = edit.val()
      edit.hide().remove()
      this.text(value).show()
      data.hidden.val value
      data.edit = null
      
    toggle: (event)->
      unless  this.data('EditMe')
        log "Element doest\'t initialized with plugin #{pluginName}", this
        return this
      log this.data('EditMe')
      if this.data('EditMe').edit
        this.editMe('deactivate')
      else
        this.editMe('activate')

    change: (event)->
      unless  this.data('EditMe')
        log "Element doest\'t initialized with plugin #{pluginName}", this
        return this
      data = this.data('EditMe')
      edit = data.edit
      value = edit.val()
      this.text value
      data.hidden.val value
      applyStyles this, edit


  #Private
  getInputName = (el)->
    inputName = if id = el.attr('id') then id else null
    if name = el.data('name') then inputName = name
    return inputName # ignore fields with undefined id or data-name

  createHiddenInput = (el)->
    hidden = $("<input/>",
      name: "#{opts.hiddenPrefix}#{el.data('EditMe').name}#{opts.hiddenSuffix}"
      type: "hidden"
      value: $.trim el.text()
    )
    el.after hidden
    el.data('EditMe').hidden = hidden

  createEditInput = (el)->
    input = $('<input/>',
      #name: 'input_' + inputName
      type: "text"
      class: "editMe"
      value: $.trim el.text()
    )
    input.on opts.deactivateEvent, (event)-> el.editMe('deactivate', event)
    input.on opts.syncEvent, (event)-> el.editMe('change', event)
    el.after input
    el.data('EditMe').edit = input

    applyStyles el, input
  #end
 
  applyStyles = (src, dest)->
    dest.height src.height()
    dest.width src.width()

  
  # Util
  log = (msg, other...)->
    if opts.debug
      console.log "DUBUG:", msg, other

  $.fn.editMe = (method) ->
    if methods[method]
      #TODO: check if element covered with plugin
      methods[method].apply  this, Array.prototype.slice.call( arguments, 1)
    else if typeof method is 'object' || ! method
      methods.init.apply this, arguments
    else
      log "Method #{method} does not exist on jQuery.#{pluginName}"
)(jQuery)
