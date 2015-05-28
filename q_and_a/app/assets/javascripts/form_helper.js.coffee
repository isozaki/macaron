$ ->
        $('form button[type=reset], form a[type=reset]').bind 'click', (e) ->
                e.preventDefault()
                $(this).closest('form').find(':input[type=text]').each ->
                        this.value = ''
