return {
    {
        'echasnovski/mini.move',
        version = '*',
        opts = {
          mappings = {
            -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
            left = 'H',
            right = 'L',
            down = 'J',
            up = 'K',

            -- Move current line in Normal mode
            line_left = 'H',
            line_right = 'L',
          },
        },
    },
}
