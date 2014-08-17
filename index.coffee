through2 = require 'through2'

# requires = ['html']

module.exports = (options = { blog: { } }) ->
    { blog } = options
    processFile = (file, enc, done) ->
        file.isPost = yes
        file.type = 'text'
        file.images = []
        file.videos = []
        file.audios = []
        file.links = []

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