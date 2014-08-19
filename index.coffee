path = require 'path'
through2 = require 'through2'

# requires = ['html']

module.exports = (options = { blog: { } }) ->
    { blog } = options
    processFile = (file, enc, done) ->
        if path.extname(file.path).match /.html?/i
            file.isPost = yes

            if not file.author
                try file.author = blog.author || blog.authors[0]

            file.type = 'text'
            file.stats =
                images: []
                videos: []
                audios: []
                links: []

            _extname = path.extname file.path
            file.id =
                path.basename(file.path)
                .replace (new RegExp "#{_extname}$", 'i'), ''

            if file.$
                { $ } = file

                isDescriptive = (i, paragraph) ->
                    $paragraph = $ paragraph
                    $paragraph.text().trim().match /\.$/gi

                file.title = $('h1').first().text().trim()
                file.image = $('img').first().attr('src') || null

                # @TODO: enhance excerpt
                file.excerpt =
                    $('p').filter(isDescriptive)
                    .html()

                # Inherit properties from blog
                try
                    for key in ['author', 'language']
                        file[key] = blog[key] if not file[key]

        done null, file

    through2.obj processFile