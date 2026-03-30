-- 普通模式：将 ? 映射为 gcc，并允许进一步映射 (remap = true)
vim.keymap.set('n', '?', 'gcc', { remap = true, desc = 'Toggle comment line' })

-- 可视模式：将 ? 映射为 gc，并允许进一步映射 (remap = true)
vim.keymap.set('v', '?', 'gc', { remap = true, desc = 'Toggle comment selection' })


