# IE 7 Fix
if not Array.prototype.indexOf
  Array.prototype.indexOf = (object, start)->
    for index in [start..this.length]
      if this[index] is object
        index
    -1
