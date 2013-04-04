(($) ->
  $.fn.getStyleObject = ->
    dom = this.get(0)
    returns = {}
    if window.getComputedStyle
      camelize = (a,b) ->
        b.toUpperCase()
        
      style = window.getComputedStyle dom, null
      for prop in style
        camel = prop.replace /\-([a-z])/, camelize
        val = style.getPropertyValue prop
        returns[camel] = val
        
      returns
    
    if dom.currentStyle
      style = dom.currentStyle
      for prop in style
        returns[prop] = style[prop]
      returns
    
    if style = dom.style
      for prop in style
        if typeof style[prop] != 'function'
          returns[prop] = style[prop]
      returns
    return returns
)(jQuery)
