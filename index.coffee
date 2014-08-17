through2 = require 'through2'
{ guessDir, isRTL, isLTR } = require '../utils'

# requires = ['html']

module.exports = (options = { blog: { } }) ->
    { blog } = options
    processFile = (file, enc, done) ->
        # @TODO @FIXME get rid of this
        file.type = 'text'

        file.isPost = yes
        if file.$
            { $ } = file
            getTextDir = (fallback) ->
                text = $.root().clone().remove('pre').text()
                guessDir text, fallback

            isDescriptive = (i, paragraph) ->
                $paragraph = $ paragraph
                $paragraph.text().trim().match /\.$/gi

            file.title = $('h1').first().text().trim()
            file.image = $('img').first().attr('src') || null

            # @TODO: enhance excerpt
            file.excerpt =
                $('p').filter(isDescriptive)
                .html()

            file.dir = getTextDir blog.dir || 'ltr' if not file.dir

            # Inherit properties from blog
            try
                for key in ['author', 'language']
                    file[key] = blog[key] if not file[key]


        done null, file

    through2.obj processFile