
Sidebar = (tree) ->
    selectFileCallback = (file, project) ->
    changeProjectCallback = (project) ->
    newFileCallback = (file, project) -> return true
    selectedProject = ''
    selectedFile = ''
    tree = {} unless tree?

    updateView = ->
        t = []

        for key, elements of content
            proj = {name: key, children: []}
            proj.children.push({name: file, children: [], parent: key}) for file in elements
            proj.children.push({name: '<span class="fa fa-plus">nouveau ...', children: []})
            t.push proj

        t.push {name: '<span class="fa fa-plus">nouveau projet ...', children: []}
        view = new TreeView(tree, 'tree')

        view.on 'select', (e) ->
            if e.data.children.length == 0 # if it's not a project
                if selectedProject isnt e.data.parent
                    selectedProject = e.data.parent
                    changeProjectCallback(selectedProject)

                if e.data.name is '<span class="fa fa-plus">nouveau ...'
                    tree[selectedProject].push '<input class="new-file-input">'
                    updateView()
                    $('.new-file-input').change ->
                        tree[selectedProject].pop()
                        exists = no
                        exists |= file is this.val() for file in tree[selectedProject]
                        if not exists and newFileCallback(this.val(), selectedProject)
                            tree[selectedProject].push this.val()
                else if e.data.name is '<span class="fa fa-plus">nouveau projet ...'
                    
                else
                    selectedFile = e.data.name
                    selectFileCallback(e.data.name, e.data.parent)



    result =
        selectFile: (callback) -> selectFileCallback = callback
        changeProject: (callback) -> changeProjectCallback = callback
        newFile: (callback) -> newFileCallback = callback

        addFile: (project, file) ->
            unless tree[project]?
                console.log 'project doesn\'t exist'
                return
            tree[project].push file
            updateView()
        getTree: () -> return tree
        setTree: (t) ->
            tree = t
            updateView()

    return result
