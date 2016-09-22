modelist = ace.require("ace/ext/modelist")
editor = ace.edit "editor"
editor.setTheme("ace/theme/monokai")
editor.setOption("scrollPastEnd", 0.3)

mode = modelist.getModeForPath("a.java").mode
console.log mode

editor.getSession().setMode(mode)
