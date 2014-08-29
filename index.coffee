path = require 'path'
through2 = require 'through2'

module.exports = (options = { blog: { } }) ->
    { blog } = options
    processFile = (file, enc, done) ->
        if path.extname(file.path).match /.html|.md|.mdown|.gfm|.markdown/i
            file.isPost = yes

            if not file.author
                try file.author = blog.author || blog.authors[0]

            file.type = 'text'

            file.images = []
            file.videos = []
            file.audios = []
            file.links = []
            
            file.categories = []

            file.styles = []
            file.scripts = []

            _extname = path.extname file.path
            file.id =
                path.basename(file.path)
                .replace (new RegExp "#{_extname}$", 'i'), ''

            # Inherit properties from blog
            for key in ['author', 'language']
                try file[key] = blog[key] if not file[key]

        done null, file

    through2.obj processFile